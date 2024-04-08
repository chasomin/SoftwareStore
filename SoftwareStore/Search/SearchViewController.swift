//
//  SearchViewController.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController, CommonViewController {
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()

    private let customNavigationView = NavigationView()
    private let tableView = UITableView()
    private let freeAppFilterButton = UIButton()
    private let paidAppFilterButton = UIButton()
    private let hStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func bind() {
        
        let input = SearchViewModel.Input(searchButtonTap: customNavigationView.searchBar.rx.searchButtonClicked, searchText: customNavigationView.searchBar.rx.text, tableViewItem: tableView.rx.modelSelected(Result.self), freeButtonTap: freeAppFilterButton.rx.tap, paidButtonTap: paidAppFilterButton.rx.tap)
        let output = viewModel.transform(input: input)
        output.software
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.id, cellType: SearchTableViewCell.self)) { row, element, cell in
                cell.configureCell(element: element)
                
                cell.downloadButton.rx.tap
                    .map { element.formattedPrice }
                    .bind(with: self, onNext: { owner, value in
                        owner.showAlert(text: value)
                    })
                    .disposed(by: cell.disposeBag)

            }
            .disposed(by: disposeBag)
        
        output.selectSofeware
            .drive(with: self) { owner, result in
                let vc = SoftwareDetailViewController(software: result)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.freeButtonTap
            .drive(with: self) { owner, result in
                owner.paidAppFilterButton.configuration = UIButton.unselectedButton()
                owner.paidAppFilterButton.setTitle("유료 앱", for: .normal)
                owner.freeAppFilterButton.configuration = UIButton.selectedButton()
            }
            .disposed(by: disposeBag)
        
        output.paidButtonTap
            .drive(with: self) { owner, result in
                owner.freeAppFilterButton.configuration = UIButton.unselectedButton()
                owner.paidAppFilterButton.configuration = UIButton.selectedButton()
                owner.freeAppFilterButton.setTitle("무료 앱", for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.networkError
            .drive(with: self) { owner, _ in
                owner.showToast()
            }
            .disposed(by: disposeBag)


        
//        output.downloadTap
//            .withLatestFrom(output.selectSofeware)
//            .map { $0.price.description }
//            .debug()
//            .drive(with: self, onNext: { owner, value in
//                owner.showAlert(text: value)
//            })
//            .disposed(by: disposeBag)
        
    }
}

extension SearchViewController {
    private func configureView() {
        view.backgroundColor = .systemMint
        view.addSubview(customNavigationView)
        view.addSubview(hStack)
        view.addSubview(tableView)
        hStack.addArrangedSubview(freeAppFilterButton)
        hStack.addArrangedSubview(paidAppFilterButton)
        
        customNavigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        hStack.snp.makeConstraints { make in
            make.top.equalTo(customNavigationView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(hStack.snp.bottom).offset(15)
            make.bottom.horizontalEdges.equalTo(view)
        }
        
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.distribution = .fillEqually

        freeAppFilterButton.setTitle("무료 앱", for: .normal)
        freeAppFilterButton.configuration = UIButton.selectedButton()
        paidAppFilterButton.setTitle("유료 앱", for: .normal)
        paidAppFilterButton.configuration = UIButton.selectedButton()

        tableView.backgroundColor = .black
        tableView.layer.cornerRadius = 30
        tableView.rowHeight = 100
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
    }
}

extension UIViewController {
    func showAlert(text: String) {
        let alert = UIAlertController(title: "가격", message: "이 상품의 가격은 \(text) 입니다!", preferredStyle: .alert)
        let button = UIAlertAction(title: "확인", style: .default)
        alert.addAction(button)
        present(alert, animated: true)
    }
}


extension UIButton {
    static func selectedButton() -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .systemMint
        return config
    }
    
    static func unselectedButton() -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.baseForegroundColor = .black
        return config
    }
}
