//
//  GameViewModel.swift
//  BrainBurst
//
//  Created by J_Min on 2023/06/10.
//

import Foundation
import GroupActivities

struct GameResult: Codable, Hashable {
    var id: UUID = UUID()
    var userId: String
    var score: Int
}

class GameViewModel: ObservableObject {
    
    @Published var quizes: [Quiz] = []
    @Published var resultName: GameResult = GameResult(userId: "", score: 0)
    
    var gameManager: GameManager
    var messenger: GroupSessionMessenger?
    var tasks = Set<Task<Void, Never>>()
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
    }
    
    func startSharing() {
        Task {
            do {
                _ = try await GameGroupActivity().activate()
            } catch {
                print("can't sharing")
            }
        }
    }
    
    func configureGroupSession(_ session: GroupSession<GameGroupActivity>) {
        let messenger = GroupSessionMessenger(session: session)
        self.messenger = messenger
        
        let quizeTask = Task {
            for await (model, _) in messenger.messages(of: [MentalArithmetic].self) {
                loadQuizes(model)
            }
        }
        
        let resultTask = Task {
            for await (model, _) in messenger.messages(of: GameResult.self) {
                loadGameResult(model)
            }
        }
        tasks.insert(quizeTask)
        tasks.insert(resultTask)
        session.join()
    }
    
    func loadQuizes(_ quizes: [MentalArithmetic]) {
        print(quizes)
        DispatchQueue.main.async { [weak self] in
            self?.quizes = quizes
        }
    }
    
    func loadGameResult(_ result: GameResult) {
        print(result)
        DispatchQueue.main.async { [weak self] in
            self?.resultName = result
        }
    }
    
    func sendQuiz() {
        let quizes = gameManager.makeQuiz((0...5).randomElement()!)
        self.quizes = quizes
        
        let mentalArithmeticQuizs = quizes.map { $0 as! MentalArithmetic }
        Task {
            do {
                try await messenger?.send(mentalArithmeticQuizs)
            } catch {
                print("can't send")
            }
        }
    }
    
    func sendResult() {
        let result = GameResult(userId: ["asdf", "hr5w"].randomElement()!, score: 3)
        
        Task {
            do {
                try await messenger?.send(result)
            } catch {
                print("can't send")
            }
        }
    }
}
 
