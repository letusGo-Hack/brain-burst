//
//  RankView.swift
//  BrainBurst
//
//  Created by 고대원 on 2023/06/10.
//

import SwiftUI
import SwiftData

struct RankView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var didLoad: Bool = false
    
    var gameResults: [GameResult]
    private var sortedGameResults: [GameResult] {
        return gameResults.sorted { s1, s2 in
            return s1.score > s2.score
        }
    }
    
    var body: some View {
        NavigationView(content: {
            List {
                ForEach(Array(sortedGameResults.enumerated()), id: \.element) { (index, gameResult) in
                    historyView(index: index + 1, gameResult: gameResult)
                        .alignmentGuide(.listRowSeparatorLeading, computeValue: { dimension in
                            return 0
                        })
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Rank")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            })
        })
        .onAppear(perform: {
            if didLoad == false {
                didLoad = true
            }
            
            if let gameResult = sortedGameResults.enumerated().filter({ $1.userId == UserInfo.uuid }).first {
                let gameResultHisotry = GameResultHistory(
                    rank: gameResult.offset + 1,
                    score: gameResult.element.score,
                    endDate: Date(),
                    createDate: Date()
                )
                context.insert(gameResultHisotry)
                try? context.save()
            }
        })
    }
    
    func historyView(index: Int, gameResult: GameResult) -> some View {
        HStack {
            Text("\(index)")
                .frame(maxWidth: .infinity)
            
            Text("\(gameResult.userId)")
                .frame(maxWidth: .infinity)
            
            Text("\(gameResult.score)")
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
        .sheet(
            isPresented: Binding.constant(true),
            content: {
                RankView(
                    gameResults: [
                        GameResult(userId: "kim", score: 13),
                        GameResult(userId: "ss", score: 11),
                        GameResult(userId: "min", score: 10),
                        GameResult(userId: "bb", score: 14),
                    ]
                )
                .modelContainer(for: GameResultHistory.self)
            }
        )
}
