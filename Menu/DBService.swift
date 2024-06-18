//
//  DBService.swift
//  Menu
//
//  Created by Satoko Fujiyoshi on 2024/06/15.
//

import Foundation
import SQLite3

final class DBService {
    static let shared = DBService()
    
    private let dbFile = "DataBase.sqlite"
       private var db: OpaquePointer?
       
       private init() {
          db = openDatabase()
          if db != nil {
              if !createAccountTable() {
                  print("Failed to create accounts table")
              } else {
                  print("Accounts table created successfully")
              }
              
              if !createIngredientTable() {
                  print("Failed to create ingredients table")
              } else {
                  print("Ingredients table created successfully")
              }
          }
       }
       
       private func openDatabase() -> OpaquePointer? {
           let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: false).appendingPathComponent(dbFile)
           
           print(fileURL)
           var db: OpaquePointer? = nil
           if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
               print("Failed to open database")
               return nil
           }
           else {
               print("Opened connection to database")
               return db
           }
       }
    
    //accountsテーブルの作成
    private func createAccountTable() -> Bool {
           let createSql = """
           CREATE TABLE IF NOT EXISTS accounts (
               account_id TEXT NOT NULL PRIMARY KEY,
               password TEXT NOT NULL
           );
           """
           
        return executeSQL(createSql)
    }
    
    //ingredientsテーブルの作成
    private func createIngredientTable() -> Bool {
           let createSql = """
           CREATE TABLE IF NOT EXISTS ingredients (
               number INTEGER PRIMARY KEY AUTOINCREMENT,
               account_id TEXT NOT NULL,
               ingredient TEXT NOT NULL
           );
           """
           
        return executeSQL(createSql)
    }
            
    
    private func executeSQL(_ sql: String) -> Bool {
            var stmt: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
                print("db error: \(getDBErrorMessage(db))")
                return false
            }
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("db error: \(getDBErrorMessage(db))")
                sqlite3_finalize(stmt)
                return false
            }
            sqlite3_finalize(stmt)
            return true
        }
        
    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
            if let err = sqlite3_errmsg(db) {
                return String(cString: err)
            } else {
                return ""
            }
        }
    
    //アカウントの追加
    func insertAccount(account: Account) -> Bool {
        let insertSql = """
                        INSERT INTO accounts
                            (account_id, password)
                            VALUES
                            (?, ?);
                        """;
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_text(insertStmt, 1, (account.AccountID as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 2, (account.Password as NSString).utf8String, -1, nil)
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(insertStmt)
            return false
        }
        sqlite3_finalize(insertStmt)
        return true
    }
    
    //アカウント情報の取得
    func getAccount(AccountId: String) -> (success: Bool, errorMessage: String?, account: Account?) {
     
        var account: Account? = nil
        
        let sql = """
            SELECT  account_id, password
            FROM    accounts
            WHERE   account_id = ?;
            """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", account)
        }
        
        sqlite3_bind_text(stmt, 1, (AccountId as NSString).utf8String, -1, nil)
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let accountID = String(describing: String(cString: sqlite3_column_text(stmt, 0)))
            let password = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            
            account = Account(AccountID: accountID, Password: password)
        }
        
        sqlite3_finalize(stmt)
        return (true, nil, account)
    }
    
    //食材の追加
    func insertIngredients(ingredient: Ingredients) -> Bool {
        let insertSql = """
                        INSERT INTO ingredients
                            (account_id, ingredient)
                            VALUES
                            (?, ?);
                        """;
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_text(insertStmt, 1, (ingredient.AccountID as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 2, (ingredient.Ingredient as NSString).utf8String, -1, nil)
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(insertStmt)
            return false
        }
        sqlite3_finalize(insertStmt)
        return true
    }
    
    //食材の削除
    func deleteIngredient(Number: Int) -> Bool {
        let deleteSql = "DELETE FROM ingredients WHERE number = ?;";
        var deleteStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (deleteSql as NSString).utf8String, -1, &deleteStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_int(deleteStmt, 1,Int32(Number))
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(deleteStmt)
            return false
        }

        sqlite3_finalize(deleteStmt)
        return true
    }
    
    //食材の取得
    func getIngredietns(AccountId: String) -> (success: Bool, errorMessage: String?, ingredients: [Ingredients]?) {
     
        var ingredients: [Ingredients] = []
        
        let sql = """
            SELECT  number, account_id, ingredient
            FROM    ingredients
            WHERE   account_id = ?;
            """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", ingredients)
        }
        
        sqlite3_bind_text(stmt, 1, (AccountId as NSString).utf8String, -1, nil)
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let number = Int(sqlite3_column_int(stmt, 0))
            let accountID = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            let ingredient = String(describing: String(cString: sqlite3_column_text(stmt, 2)))
            
            let ingredientObject = Ingredients(Number: number, AccountID: accountID, Ingredient: ingredient)
            ingredients.append(ingredientObject)
        }
        
        sqlite3_finalize(stmt)
        return (true, nil, ingredients)
    }
}
