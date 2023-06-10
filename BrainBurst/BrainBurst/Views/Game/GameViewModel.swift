//
//  GameViewModel.swift
//  BrainBurst
//
//  Created by J_Min on 2023/06/10.
//

import Foundation
import GroupActivities

class GameViewModel: ObservableObject {
    
    var quizs: [Quiz] = []
    
    var messenger: GroupSessionMessenger?
    var tasks = Set<Task<Void, Never>>()
    
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
        
        let task = Task {
            for await (model, _) in messenger.messages(of: [MentalArithmetic].self) {
                handle(model)
            }
        }
        tasks.insert(task)
        session.join()
    }
    
    func handle(_ quizs: [MentalArithmetic]) {
        print(quizs)
        self.quizs = quizs
    }
    
    func send(_ quizs: [Quiz]) {
        let mentalArithmeticQuizs = quizs.map { $0 as! MentalArithmetic }
        Task {
            do {
                try await messenger?.send(mentalArithmeticQuizs)
            } catch {
                print("can't send")
            }
        }
    }
}
