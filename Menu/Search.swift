//
//  Search.swift
//  Menu
//
//  Created by Satoko Fujiyoshi on 2024/05/05.
//

import SwiftUI
//HTTP通信する
import Alamofire
//スクレイピング
import Kanna

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let url: String
}

struct Search: View {
    @ObservedObject var myMenu: MyMenu
    @State private var isReturn: Bool = false
    
    @State var myIngredients: [Ingredients] = []
    @State var recipes: [Recipe] = []
    
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
                //検索ボタン
                Button(action:{
                    searchMenu()
                }, label: {
                    Text("検索")
                        .fontWeight(.medium)
                        .frame(minWidth: 110)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(.orange)
                        .cornerRadius(8)
                })//Button
                List(recipes){ recipe in
                    VStack(alignment: .leading){
                        Text(recipe.title)
                        Text(recipe.url)
                            .foregroundColor(.blue)
                            .underline()
                            .onTapGesture {
                                if let url = URL(string: recipe.url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                }
            }
        }//ZStack
    }

    private func searchMenu(){
        let (success, errorMessage, ingredients) = DBService.shared.getIngredietns(AccountId: myMenu.myId)
        if success {
                if let ingredients = ingredients {
                    let searchWord = ingredients.map { $0.Ingredient }.joined(separator: "")
                    print(searchWord)
                    
                    getReceipt(searchWord: searchWord)
                    
                } else {
                    print("Ingredients is nil")
                }
            } else {
                print(errorMessage ?? "Error")
            }
    }
    //スクレイピング
    private func getReceipt(searchWord: String){
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print("https://delishkitchen.tv/search?q=\(encodedSearchWord)")
        AF.request("https://delishkitchen.tv/search?q=\(encodedSearchWord)").responseString { response in
            switch response.result {
            case let .success(value):
                if let doc = try? HTML(html: value, encoding: .utf8) {
                    //検索結果のレシピタグの取得
                    for i in 1... {
                        if let link = doc.at_xpath("//*[@id='main']/div/div[2]/article/div/ul/li[\(i)]/div/a")?["href"],
                           let title = doc.at_xpath("//*[@id='main']/div/div[2]/article/div/ul/li[\(i)]/div/a/div[2]/p[1]")?.text {
                            let recipe = Recipe(title: title, url: "https://delishkitchen.tv\(link)")
                            recipes.append(recipe)
                        }
                        else{
                            break
                        }
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

#Preview {
    Search(myMenu: MyMenu())
}
