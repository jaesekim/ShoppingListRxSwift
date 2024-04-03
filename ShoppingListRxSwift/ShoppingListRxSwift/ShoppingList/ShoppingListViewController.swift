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

    
    var itemList: [ShopModel] = [ShopModel(item: "a")]
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "쇼핑"
        bind()
//        configureDataSource()
//        updateSnapshot()
    }
    
    private func bind() {
        
        viewModel.outputShoppingItem
            .asDriver()
            .drive(mainView.tableView.rx.items(
                cellIdentifier: "ShoppingListViewTableViewCell",
                cellType: ShoppingListViewTableViewCell.self)
            ) { (row, element, cell) in
                cell.updateUI(element)
            }
            .disposed(by: disposeBag)
        
        mainView.addButton.rx.tap
            .bind(to: viewModel.inputAddButtonTap)
            .disposed(by: disposeBag)

        mainView.textField.rx.text.orEmpty
            .bind(to: viewModel.inputShoppingItem)
            .disposed(by: disposeBag)
        
        // addButton.isEnable 여부 바인딩
        viewModel.outputButtonStatus
            .asDriver()
            .drive(with: self) { owner, bool in
                owner.mainView.addButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
    }
}

extension ShoppingListViewController {
    
    // 이거 왜 안 되는거야;
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
    
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ShopModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.itemList, toSection: .main)

        dataSource.apply(snapshot)
    }
}
