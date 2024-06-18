//
//  Ingredients.swift
//  Menu
//
//  Created by Satoko Fujiyoshi on 2024/06/16.
//

import Foundation
struct Ingredients {
    var Number: Int
    var AccountID: String
    var Ingredient: String
    
    init(Number:Int, AccountID: String, Ingredient: String) {
        self.Number = Number
        self.AccountID = AccountID
        self.Ingredient = Ingredient
    }
}
