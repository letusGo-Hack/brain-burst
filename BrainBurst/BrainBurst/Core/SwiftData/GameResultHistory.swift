//
//  GameResultHistory.swift
//  BrainBurst
//
//  Created by 고대원 on 2023/06/10.
//

import Foundation
import SwiftData

@Model
class GameResultHistory {
    var id: UUID
    var rank: Int
    var score: Int
    var endDate: Date
    var createDate: Date
    
    init(rank: Int, score: Int, endDate: Date, createDate: Date) {
        self.id = UUID()
        self.rank = rank
        self.score = score
        self.endDate = endDate
        self.createDate = createDate
    }
}

/*
 ContentView()
     .modelContainer(for: GameResultHistory.self)
 
ContentView.Swift
 @Environment(\.modelContext) private var context
 
Insert
 let history = GameResultHistory(
    rank: 1,
    score: 1,
    endDate: Date(),
    createDate: Date()
 )
 context.insert(history)
 do {
     try context.save()
 } catch {
     
 }
 */
