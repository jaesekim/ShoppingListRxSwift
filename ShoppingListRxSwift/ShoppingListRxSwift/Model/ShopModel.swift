//
//  ShopModel.swift
//  ShoppingListRxSwift
//
//  Created by 김재석 on 4/4/24.
//

import Foundation

struct ShopModel: Hashable {
    let id = UUID()
    let item: String
    let done = false
    let selected = false
}
