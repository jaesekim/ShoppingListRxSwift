//
//  ShoppingListViewModel.swift
//  ShoppingListRxSwift
//
//  Created by 김재석 on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingListViewModel {
    
    let inputAddButtonTap = PublishSubject<Void>()
    let inputShoppingItem = PublishSubject<String>()
    
    var itemList: [ShopModel] = []
    
    lazy var outputShoppingItem = BehaviorRelay(value: itemList)
    let outputButtonStatus = BehaviorRelay(value: false)
    
    let disposeBag = DisposeBag()

    init() {
        
        inputAddButtonTap
            .withLatestFrom(inputShoppingItem)
            .distinctUntilChanged()
            .bind(with: self) { owner, item in
                print("click")
                print(item)
                owner.itemList.append(ShopModel(item: item))
                owner.outputShoppingItem.accept(owner.itemList)
            }
            .disposed(by: disposeBag)
        
        inputShoppingItem
            .map { !$0.isEmpty }
            .bind(with: self) { owner, bool in
                owner.outputButtonStatus.accept(bool)
            }
            .disposed(by: disposeBag)
        
        inputShoppingItem
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                let result = text.isEmpty ? 
                owner.itemList : owner.itemList.filter { $0.item.contains(text) }
                owner.outputShoppingItem.accept(result)
            }
            .disposed(by: disposeBag)
        
        
    }
}
