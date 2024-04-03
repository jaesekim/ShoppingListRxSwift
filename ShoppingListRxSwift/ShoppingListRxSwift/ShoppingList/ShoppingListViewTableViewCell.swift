//
//  ShoppingListViewTableViewCell.swift
//  ShoppingListRxSwift
//
//  Created by 김재석 on 4/4/24.
//

import UIKit
import SnapKit
import RxSwift

class ShoppingListViewTableViewCell: UITableViewCell {

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
    
    var dispose = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        configureHierarchy()
        configureConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 12, left: 0, bottom: 0, right: 0
            )
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(_ element: ShopModel) {
        shoppingLabel.text = element.item
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dispose = DisposeBag()
    }
}

extension ShoppingListViewTableViewCell {
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
