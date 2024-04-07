//
//  SoftwareDetailViewController.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SoftwareDetailViewController: UIViewController, CommonViewController {
    let viewModel = SoftwareDetailViewModel()
    let disposeBag = DisposeBag()

    let software: Result
    
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let appNameLabel = UILabel()
    let appIconImageView = UIImageView()
    let downloadButton = UIButton()
    let descriptionLabel = UILabel()
    let artistNameLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bind()
    }
    
    private func bind() {
        let input = SoftwareDetailViewModel.Input(data: BehaviorSubject(value: software), downloadButtonTap: downloadButton.rx.tap)
        let output = viewModel.transform(input: input)
        output.data
            .map { $0.screenshotUrls }
            .debug()
            .drive(collectionView.rx.items(cellIdentifier: ScreenShotCollectionViewCell.id, cellType: ScreenShotCollectionViewCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        output.downloadButtonTap
            .drive(with: self) { owner, _ in
                guard let url = URL(string: owner.software.trackViewUrl) else { return }
                owner.present(WebViewController(url: URLRequest(url: url)), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    init(software: Result) {
        self.software = software
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SoftwareDetailViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 124.2, height: 220.8)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        return layout
    }

    private func configureView() {
        view.backgroundColor = .black

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(appIconImageView)
        contentView.addSubview(downloadButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(collectionView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        
        appIconImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(15)
            make.size.equalTo(100)
        }
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView).inset(10)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(15)
        }
        artistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(appIconImageView.snp.trailing).offset(10)
            make.top.equalTo(appNameLabel.snp.bottom).offset(10)
        }
        downloadButton.snp.makeConstraints { make in
            make.bottom.equalTo(appIconImageView)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(contentView).inset(15)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(contentView).inset(15)
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(220.8)
        }
        
        appIconImageView.kf.setImage(with: URL(string: software.artworkUrl512))
        appIconImageView.layer.cornerRadius = 15
        appIconImageView.clipsToBounds = true
        appNameLabel.text = software.trackName
        appNameLabel.font = .boldSystemFont(ofSize: 17)
        appNameLabel.textColor = .white
        artistNameLabel.text = software.artistName
        artistNameLabel.font = .systemFont(ofSize: 12)
        artistNameLabel.textColor = .lightGray
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .systemMint
        config.baseForegroundColor = .black
        config.title = "받기"
        downloadButton.configuration = config
        descriptionLabel.text = software.description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        collectionView.register(ScreenShotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenShotCollectionViewCell.id)
        collectionView.backgroundColor = .clear
    }
}
