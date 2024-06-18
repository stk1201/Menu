//
//  Newaccount.swift
//  Menu
//
//  Created by Satoko Fujiyoshi on 2024/04/23.
//

import SwiftUI
import CoreData

struct Newaccount: View {
    
    @State var newInputId: String = ""
    @State var newInputPassword: String = ""
    @State var errorMessage: String = ""
    
    @State private var isNewPressed: Bool = false
    @State private var isReturn: Bool = false
   
    var body: some View {
        ZStack(){
            Image("NewAccountPage")
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
                       LoginView()
                    }
                    Spacer()
                }
                Spacer()
                Text("新規アカウント")
                    .font(.system(size: 48, weight: .heavy))
                
                VStack(spacing: 24){
                    TextField("新しいID", text: $newInputId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                    SecureField("新しいパスワード", text: $newInputPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                }
                .frame(height: 200)
                
                Button(action:{
                    addAccount()
                },
                   label:{
                       Text("アカウントの作成")
                           .fontWeight(.medium)
                           .frame(minWidth: 110)
                           .foregroundColor(.white)
                           .padding(12)
                           .background(.orange)
                           .cornerRadius(8)
                            
                   }//label
                )//Button
                //ログイン画面に遷移する
                .fullScreenCover(isPresented: $isNewPressed){
                    LoginView()
                }
                //エラーメッセージの表示
                Text(errorMessage)
                    .foregroundColor(.red)
                Spacer()
            }
        }//ZStack
    }
    private func addAccount(){
        
        if newInputId.isEmpty || newInputPassword.isEmpty{
            errorMessage = "入力してください。"
            return
        }
        else{
            let account = Account(AccountID: newInputId, Password: newInputPassword)
                    
            if DBService.shared.insertAccount(account: account) {
                print("追加成功")
                isNewPressed = true
            } else {
                print("追加失敗")
            }
        }
    }//addAccount
}

#Preview {
    Newaccount()
}
