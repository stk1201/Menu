//
//  IngredientEditView.swift
//  Menu
//
//  Created by Satoko Fujiyoshi on 2024/05/05.
//

import SwiftUI

struct IngredientEditView: View {
    @ObservedObject var myMenu: MyMenu
    @State private var isReturn: Bool = false
    
    @State var allIngredients:[String] = ["鶏肉","豚肉","牛肉","ひき肉","鮭","キャベツ","人参","玉ねぎ","じゃがいも","とうもろこし","白菜","舞茸","しめじ"]
    @State var selectedIngredient:String = "鶏肉"
    @State var myIngredients: [Ingredients] = []
    
    var body: some View {
        ZStack(){
            Image("OtherPage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(){
                HStack(){
                    //戻るボタン
                    Button(action:{
                        isReturn = true
                    }, label: {
                        Text("< 戻る")
                            .fontWeight(.medium)
                            .frame(minWidth: 50)
                            .foregroundColor(Color.accentColor)
                            .padding(12)
                            .cornerRadius(8)
                    })//Button
                    .fullScreenCover(isPresented:$isReturn){
                        HomeView(myMenu: myMenu)
                    }
                    Spacer()
                }
                HStack(){
                    Picker(selection: $selectedIngredient, label: Text("食材").foregroundColor(.black), content: {
                        ForEach(allIngredients, id:\.self) { value in
                            Text("\(value)")
                                .foregroundColor(.black)
                                .tag(value)
                        }
                    })
                    .onChange(of: selectedIngredient) { newValue in
                                    print(newValue)
                                    // Do with selected vzalue
                    }
                    //追加ボタン
                    Button(action:{
                        addIngredient()
                    }, label: {
                        Text("追加")
                            .fontWeight(.medium)
                            .frame(width: 50, height: 10)
                            .foregroundColor(.white)
                            .padding(20)
                            .background(.orange)
                            .cornerRadius(8)
                    })//Button
                }//HStack
                List(myIngredients, id: \.Number) { ingredient in
                    HStack(){
                        Text("\(ingredient.Ingredient)")
                        Spacer()
                        //削除ボタン
                        Button(action:{
                            deleteIngredient(number: ingredient.Number)
                        }, label: {
                            ZStack {
                               Circle()
                                   .fill(Color.red)
                                   .frame(width: 24, height: 24)
                               Text("×")
                                   .fontWeight(.medium)
                                   .foregroundColor(.white)
                           }
                        })//Button
                        .buttonStyle(PlainButtonStyle()) // デフォルトのボタンスタイルを無効にする
                    }
                }
            }//VStack
            .onAppear {
                myIngredients = getMyIngredients()
            }
        }//ZStack
    }//body
    
   //食材の追加
    private func addIngredient(){
        let ingredient = Ingredients(Number: 0, AccountID: myMenu.myId, Ingredient: selectedIngredient)
                
        if DBService.shared.insertIngredients(ingredient: ingredient){
            print("追加成功")
            myIngredients = getMyIngredients()
        } else {
            print("追加失敗")
        }
    }
    
    //食材の取得
    private func getMyIngredients() -> [Ingredients] {
        let (success, errorMessage, ingredients) = DBService.shared.getIngredietns(AccountId: myMenu.myId)
        if(success){
            return ingredients ?? []
        } else {
            print(errorMessage ?? "Error")
            return []
        }
    }
    
    //食事の削除
    private func deleteIngredient(number: Int){
        if DBService.shared.deleteIngredient(Number: number) {
            print("Delete success")
            myIngredients = getMyIngredients()
        } else {
            print("Delete Failed")
        }
    }
}
