//
//  ContentView.swift
//  BrainBurst
//
//  Created by J_Min on 2023/06/10.
//

import SwiftUI

struct HomeView: View {
    
    private var histories: [Int] = (1...32).map { $0 }
    @State var isPlay: Bool = false
    
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
                    ForEach(histories, id: \.self) { history in
                        historyView(row: history)
                    }
                }
                .listStyle(.plain)
                
                
                SharePlayButton(actionHandler: startGame)
                    .padding()
            }
            .padding()
            
            
        }
        .sheet(isPresented: $isPlay, content: {
            let maker = MentalArithmeticQuizMaker()
            let gameManager = GameManager(maker: maker)
            let grader = MentalArithmeticGrader(gameManager: gameManager)
            QuizGameView(grader: grader)
        })
    }
    
    
    private func historyView(row: Int) -> some View {
        HStack {
            Text("\(row)")
        }
    }
    
    private func startGame() {
        // 게임시작
        print("start Game")
        isPlay.toggle()
    }
}

#Preview {
    HomeView()
}
