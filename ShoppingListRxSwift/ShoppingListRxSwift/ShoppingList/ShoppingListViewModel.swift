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

    var itemList: [ShopModel] = []

    let disposeBag = DisposeBag()
    
    struct Input {
        
        let addButtonTap: ControlEvent<Void>
        let shoppingItem: ControlProperty<String?>
    }

    struct Output {

        let buttonStatus: Driver<Bool>
        let shoppingItems: Driver<[ShopModel]>
    }
}

extension ShoppingListViewModel {

    func transforms(input: Input) -> Output {
        
        let shopping = PublishRelay<[ShopModel]>()
        
        input.addButtonTap
            .withLatestFrom(input.shoppingItem.orEmpty)
            .distinctUntilChanged()
            .bind(with: self) { owner, item in
                owner.itemList.append(
                    ShopModel(item: item)
                )
                shopping.accept(owner.itemList)
            }
            .disposed(by: disposeBag)

        let buttonStatus = input.shoppingItem
            .orEmpty
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
            
        input.shoppingItem
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, item in
                
                let result = item.isEmpty ?
                owner.itemList : owner.itemList.filter {
                    $0.item.contains(item)
                }
                shopping.accept(result)
            }
            .disposed(by: disposeBag)
        
        let shoppingResult = shopping
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            buttonStatus: buttonStatus,
            shoppingItems: shoppingResult
        )
    }
}
