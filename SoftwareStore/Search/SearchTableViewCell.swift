//
//  SearchTableViewCell.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/5/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchTableViewCell: UITableViewCell {
    static let id = SearchTableViewCell.description()
    
    let appNameLabel = UILabel()
    let appIconImageView = UIImageView()
    let downloadButton = UIButton()
    let descriptionLabel = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(element: Result) {
        appNameLabel.text = element.trackName
        appIconImageView.kf.setImage(with: URL(string: element.artworkUrl512))
        descriptionLabel.text = element.description
    }
}

extension SearchTableViewCell {
    private func configureView() {
        contentView.backgroundColor = .black
        contentView.addSubview(appNameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(appIconImageView)
        contentView.addSubview(downloadButton)
        
        appIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
            make.size.equalTo(60)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView).inset(10)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            make.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(appIconImageView).inset(10)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            make.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.centerY.equalTo(appIconImageView)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
            make.width.equalTo(72)
        }
        
        appNameLabel.font = .boldSystemFont(ofSize: 17)
        appNameLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .white
        appIconImageView.layer.cornerRadius = 15
        appIconImageView.clipsToBounds = true
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .systemMint
        config.baseForegroundColor = .black
        config.title = "받기"
        downloadButton.configuration = config
    }
}
