//
//  NavigationView.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/5/24.
//

import UIKit
import SnapKit

class NavigationView: UIView {
    let icon = UIImageView()
    let searchBar = UISearchBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    private func configureView() {
        backgroundColor = .systemMint
        addSubview(icon)
        addSubview(searchBar)
        
        icon.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(safeAreaLayoutGuide).inset(15)
            make.width.equalTo(icon.snp.height)
        }
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(10)
            make.verticalEdges.trailing.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        icon.image = UIImage(systemName: "storefront")
        icon.tintColor = .black
        searchBar.placeholder = "앱을 검색해보세요"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
