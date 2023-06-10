//
//  GameHistoryItem.swift
//  BrainBurst
//
//  Created by 박은비 on 2023/06/10.
//

import SwiftUI

// Sample: GameReusltHistory로 변경 필요.
struct GameResultSample {
    var rank: Int
    var score: Int
    var endDate: Date
    var createDate: Date
    
    init(rank: Int, score: Int, endDate: Date, createDate: Date) {
        self.rank = rank
        self.score = score
        self.endDate = endDate
        self.createDate = createDate
    }
}

struct GameHistoryItem: View {
    
    var gameResult: GameResultSample = GameResultSample(rank: 1, score: 10, endDate: Date(), createDate: Date())
    
    var body: some View {
        HStack {
            Circle()
                .fill(Theme.colors.randomElement()!)
                .frame(width: 5, height: 5)
            
            VStack(alignment: .leading) {
                Text("\(gameResult.rank)등 \(gameResult.score)점")
                    .font(.headline)
                Text(self.gameResult.endDate, style: .date)
                    .font(.subheadline)
            }
            Spacer()
            
            
        }
    }
}

#Preview {
        GameHistoryItem()
}


