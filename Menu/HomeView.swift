//
//  HomeView.swift
//  Menu
//
//  Created by Satoko Fujiyoshi on 2024/04/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var myMenu: MyMenu
    
    @State private var isSearchPresented: Bool = false
    @State private var isIngredientPresented: Bool = false
    @State private var isLogOutPresented: Bool = false
    
    var body: some View {
        ZStack(){
            Image("HomePage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack (alignment: .center){
                Spacer()
                //挨拶
                Text("ようこそ、 \(myMenu.myId)さん！")
                    .font(.system(size: 36, weight: .heavy))
                
                Spacer()
                //ボタン
                VStack(spacing: 24){
                    
                    //レシピを探す
                    Button(action:{
                        isSearchPresented.toggle()
                    },label:{
                        Text("レシピの検索")
                            .fontWeight(.medium)
                            .frame(minWidth: 110)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.orange)
                            .cornerRadius(8)
                    })
                    .fullScreenCover(isPresented: $isSearchPresented){
                        Search(myMenu: myMenu)
                    }
                    
                    //食材の変更
                    Button(action:{
                        isIngredientPresented.toggle()
                    },label:{
                        Text("食材の変更")
                            .fontWeight(.medium)
                            .frame(minWidth: 110)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.orange)
                            .cornerRadius(8)
                    })
                    .fullScreenCover(isPresented: $isIngredientPresented){
                        IngredientEditView(myMenu: myMenu)
                    }
                    
                    //ログアウト
                    Button(action:{
                        isLogOutPresented.toggle()
                    },label:{
                        Text("ログアウト")
                            .fontWeight(.medium)
                            .frame(minWidth: 110)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.gray)
                            .cornerRadius(8)
                    })
                    .fullScreenCover(isPresented: $isLogOutPresented){
                        LoginView()
                    }
                }
                Spacer()
            }//VStack
        }//ZStack       
    }
}
