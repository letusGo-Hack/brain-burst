//
//  LoginView.swift
//  BrainBurst
//
//  Created by 고대원 on 2023/06/10.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isLogin: Bool
    
    @State private var showingAlert = false
    @State private var nickName: String = UserInfo.nickName
    
    var body: some View {
        VStack {
            Text("Brain\nBurst")
                .font(Font.system(size: 80))
            
            Spacer()
                .frame(height: 50)
            
            Text("닉네임")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
            
            TextField(
                "닉네임을 입력해주세요.",
                text: $nickName
            )
            .font(.title3)
            
            Spacer()
            
            Button(
                action: {
                    print("\(nickName)")
                    if nickName.isEmpty {
                        showingAlert = true
                    } else {
                        UserInfo.nickName = nickName
                        isLogin = true
                    }
                },
                label: {
                    Text("시작하기")
                        .fontWeight(.bold)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("알림"),
                    message: Text("닉네임을 입력해주세요"),
                    dismissButton: .default(Text("확인"))
                )
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView(isLogin: Binding.constant(false))
}
