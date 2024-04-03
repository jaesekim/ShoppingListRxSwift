//
//  ShoppingListView.swift
//  ShoppingListRxSwift
//
//  Created by 김재석 on 4/4/24.
//

import UIKit
import SnapKit

class ShoppingListView: UIView {

    let searchFrame = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    let textField = {
        let view = UITextField()
        view.placeholder = "무엇을 구매하실건가요?"
        return view
    }()
    
    let addButton = {
        let view = UIButton()
        view.layer.cornerRadius = 4
        view.setTitle("추가", for: .normal)
        view.backgroundColor = .systemGray3
        
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(
            frame: .zero, 
            collectionViewLayout: createLayout()
        )
        
        return view
    }()
    
    lazy var tableView = {
        let view = UITableView()
        view.rowHeight = 72
        view.register(
            ShoppingListViewTableViewCell.self,
            forCellReuseIdentifier: "ShoppingListViewTableViewCell"
        )
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [
            searchFrame,
            tableView,
        ].forEach { addSubview($0) }
        
        [
            textField,
            addButton,
        ].forEach { searchFrame.addSubview($0) }
    }

    private func configureConstraints() {
        searchFrame.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(60)
        }
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(60)
            make.trailing.equalToSuperview().offset(-12)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(addButton.snp.leading).offset(-12)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchFrame.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
