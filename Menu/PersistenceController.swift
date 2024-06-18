//
//  PersistenceController.swift
//  Menu
//
//  Created by Satoko Fujiyoshi on 2024/04/23.
//

import Foundation
import CoreData

//アプリ内のスタックをカプセル化するコンテナ。これを経由してデータベースを扱う
struct PersistenceController{
    let container: NSPersistentContainer
    
    init(){
        //Modelを指定する
        container = NSPersistentContainer(name: "Model")
        //Containerからstoreを読み込む処理
        //storeはEntityのインスタンス実体化などを行う
        container.loadPersistentStores{(storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error: \(error)")
            }
            
        }
        
    }
}
