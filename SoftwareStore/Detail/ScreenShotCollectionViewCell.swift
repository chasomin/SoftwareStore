//
//  ScreenShotCollectionViewCell.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/7/24.
//

import UIKit
import SnapKit

final class ScreenShotCollectionViewCell: UICollectionViewCell {
    static let id = ScreenShotCollectionViewCell.description()
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private func configureView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
    
    func configureCell(element: String) {
        imageView.kf.setImage(with: URL(string: element))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
