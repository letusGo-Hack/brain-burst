//
//  SharePlay.swift
//  BrainBurst
//
//  Created by 고대원 on 2023/06/10.
//

import Foundation
import GroupActivities

struct GameGroupActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var meta = GroupActivityMetadata()
        meta.title = "그룹게임 타이틀"
        meta.type = .generic
        
        return meta
    }
}

class GameViewModel {
    
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
