//
//  ContentView.swift
//  BrainBurst
//
//  Created by J_Min on 2023/06/10.
//

import SwiftUI

struct HomeView: View {
    
    private var histories: [Int] = (1...32).map { $0 }
//    private var histories: [GameResultHistory] = GameResultHistory.dummy
    
    var body: some View {
        
        ZStack {
            
            VStack(alignment: .leading) {
                
                //            // Page Control
                //            Text("MVP")
                //                .gridColumnAlignment(.leading)
                //                .font(.largeTitle)
                //                .bold()
                
                
                Text("Game History")
                    .gridColumnAlignment(.leading)
                    .font(.largeTitle)
                    .bold()
                
                List {
                    
                    ForEach(histories, id: \.self) { item in
                        GameHistoryItem()
                    }
                    
                }
                .listStyle(.plain)
                
            }
            .padding()
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    SharePlayButton(actionHandler: startGame)
                        .padding()
                }
            }
            
        }
        
    }
    
    
    private func historyView(row: Int) -> some View {
        HStack {
            Text("\(row)")
        }
    }
    
    private func startGame() {
        // 게임시작
        print("start Game")
        
        
    }
}

#Preview {
    HomeView()
}


