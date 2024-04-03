//
//  ShoppingListCollectionViewCell.swift
//  ShoppingListRxSwift
//
//  Created by 김재석 on 4/4/24.
//

import UIKit
import SnapKit

class ShoppingListCollectionViewCell: UICollectionViewCell {
    
    let checkBoxButton = {
        let view = UIButton()
        view.setImage(
            UIImage(systemName: "checkmark.square"),
            for: .normal
        )

        return view
    }()
    
    let starButton = {
        let view = UIButton()
        view.setImage(
            UIImage(systemName: "star"),
            for: .normal
        )
        
        return view
    }()
    
    let shoppingLabel = {
        let view = UILabel()
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(_ itemIdentifier: ShopModel) {
        shoppingLabel.text = itemIdentifier.item
    }
    
}

extension ShoppingListCollectionViewCell {
    private func configureHierarchy() {
        [
            checkBoxButton,
            starButton,
            shoppingLabel,
        ].forEach { contentView.addSubview($0) }
    }

    private func configureConstraints() {
        checkBoxButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        starButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
        shoppingLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(12)
            make.trailing.equalTo(starButton.snp.leading).offset(-12)
        }
    }
}
