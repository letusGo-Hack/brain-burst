//
//  BrainBurstApp.swift
//  BrainBurst
//
//  Created by J_Min on 2023/06/10.
//

import SwiftUI

@main
struct BrainBurstApp: App {
    
    @State private var isLogin: Bool = !UserInfo.nickName.isEmpty
    
    var body: some Scene {
        WindowGroup {
            if isLogin {
                HomeView()
            } else {
                LoginView(isLogin: $isLogin)
            }
        }
    }
}
