//
//  ContentView.swift
//  Menu
//
//  Created by Satoko Fujiyoshi on 2024/04/22.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var myMenu = MyMenu()
    
    @State var inputId: String = ""
    @State var inputPassword: String = ""
    @State var errorMessage: String = ""
    
    @State private var isNewPressed: Bool = false
    @State private var isLogPressed: Bool = false
    

    
    var body: some View {
        ZStack(){
            Image("LogInPage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack (alignment: .center){
                //タイトル
                Text("献立生成機")
                    .font(.system(size: 48, weight: .heavy))
                
                VStack(spacing: 24){
                    TextField("ID", text: $inputId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                    SecureField("パスワード", text: $inputPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                }
                .frame(height: 200)
                
                HStack(){
                    Button(action:{
                        logInButton()
                    }, label: {
                        Text("ログイン")
                            .fontWeight(.medium)
                            .frame(minWidth: 110)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.orange)
                            .cornerRadius(8)
                    })//Button
                    .fullScreenCover(isPresented:$isLogPressed){
                        HomeView(myMenu: myMenu)
                    }
                    
                    Button(action:{
                        isNewPressed = true
                    }, label: {
                        Text("新規作成")
                            .fontWeight(.medium)
                            .frame(minWidth: 110)
                            .foregroundColor(.orange)
                            .padding(12)
                            .background(.white)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(.orange))
                    })//Button
                    .fullScreenCover(isPresented:$isNewPressed){
                        Newaccount()
                    }
                }//Hstack
                Text(errorMessage)
                    .foregroundColor(.red)
            }//Vstack
        }//ZStack
    }//body View
    
    
    private func logInButton(){
        if inputId.isEmpty || inputPassword.isEmpty{
            errorMessage = "入力してください。"
            return
        }
        else{
            
            let (success, errorMessage, account) = DBService.shared.getAccount(AccountId: inputId)
            if(success){
                if let account = account {
                    if account.Password == inputPassword{
                        myMenu.myId = inputId
                        isLogPressed = true
                    }
                } else {
                    print("Account not found")
                }
            } else {
                print(errorMessage ?? "Error")
            }
            return
        }
    }
    
    
}//View
    

#Preview {
    LoginView()
}
