//
//  ShoppingListViewController.swift
//  ShoppingListRxSwift
//
//  Created by 김재석 on 4/4/24.
//

import UIKit
import RxSwift
import RxCocoa

class ShoppingListViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }

    let mainView = ShoppingListView()
    
    override func loadView() {
        view = mainView
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, ShopModel>!
    let viewModel = ShoppingListViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "쇼핑"
        bind()
        configureDataSource()
    }
    
    private func bind() {

        let input = ShoppingListViewModel.Input(
            addButtonTap: mainView.addButton.rx.tap,
            shoppingItem: mainView.textField.rx.text
        )
        
        let output = viewModel.transforms(input: input)

        output.buttonStatus
            .drive(mainView.addButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.buttonStatus
            .drive(with: self) { owner, bool in
                let color: UIColor = bool ? .systemPink : .systemGray4
                let textColor: UIColor = bool ? .white : .lightGray
                owner.mainView.addButton.backgroundColor = color
                owner.mainView.addButton.setTitleColor(textColor, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.shoppingItems
            .drive(with: self) { owner, value in
                owner.updateSnapshot(items: value)
            }
            .disposed(by: disposeBag)
    }
}

extension ShoppingListViewController {

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<
            ShoppingListCollectionViewCell, ShopModel
        > { cell, indexPath, itemIdentifier in
            
            cell.updateUI(itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: mainView.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: itemIdentifier
                )
                return cell
            }
        )
    }

    private func updateSnapshot(items: [ShopModel]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ShopModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items, toSection: .main)

        dataSource.apply(snapshot)
    }
}
