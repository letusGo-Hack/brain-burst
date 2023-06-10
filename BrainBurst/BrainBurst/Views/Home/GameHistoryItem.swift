//
//  GameHistoryItem.swift
//  BrainBurst
//
//  Created by 박은비 on 2023/06/10.
//

import SwiftUI

struct GameHistoryItem: View {
    
    var gameResult: GameResultHistory
    
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
    GameHistoryItem(gameResult: GameResultHistory.dummy.first!)
            .modelContainer(for: GameResultHistory.self)
}


