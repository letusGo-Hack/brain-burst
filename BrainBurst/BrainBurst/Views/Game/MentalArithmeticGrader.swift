//
//  MentalArithmeticGrader.swift
//  BrainBurst
//
//  Created by todoc on 2023/06/10.
//

import Foundation
import GroupActivities

final class MentalArithmeticGrader: ObservableObject {
    @Published var quiz: String = ""
    @Published var answer: Int = 0
    @Published var isMyWin: Bool = true
    @Published var gameResults: [GameResult] = [] {
        didSet {
            if gameResults.count == session?.activeParticipants.count {
                showResult.toggle()
            }
        }
    }
    @Published var showResult: Bool = false

    private var session: GroupSession<GameGroupActivity>?
    
    private var quizes: [Quiz] = [] {
        didSet {
//            currentQuize = quizes.first
        }
    }
    private var currentQuize: Quiz!{
        didSet {
            self.quiz = currentQuize.question
            self.answer = currentQuize.answer
        }
    }
    private let gameManager: GameManager
    private let quizeNumbers = 10
    
    private var result = 0
    
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
    }
    
    func viewLoaded() {
//        makeQuizes()
//        updateQuize()
    }
    
    private func makeQuizes() {
        self.quizes = gameManager.makeQuiz(quizeNumbers)
    }
    
    private func updateQuize() {
        guard let newQuize = quizes.first else {
            quiz = "결과: \(result)"
            sendResult()
            return
        }
        currentQuize = newQuize
    }
    
    func gradeProcess(_ userAnswer: String) {
        
        let userAnswerConvert = Int(userAnswer) ?? 0
        // true
        if currentQuize != nil {
            if gameManager.checkAnswer(quiz: currentQuize,
                                       userAnswer: userAnswerConvert) {
                result += 1
            }
            if !quizes.isEmpty {
                quizes.removeFirst()
                updateQuize()
            }
        }
    }
    
    func startSharing(completion: @escaping (() -> Void)) {
        Task {
            do {
                _ = try await GameGroupActivity().activate()
                completion()
            } catch {
                print("can't sharing")
            }
        }
    }
    
    var messenger: GroupSessionMessenger?
    var tasks = Set<Task<Void, Never>>()
    
    func configureGroupSession(_ session: GroupSession<GameGroupActivity>) {
        let messenger = GroupSessionMessenger(session: session)
        self.messenger = messenger
        
        self.session = session
        
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
            self?.updateQuize()
            self?.gameResults.removeAll()
        }
    }
    
    func loadGameResult(_ result: GameResult) {
        print(result)
        DispatchQueue.main.async { [weak self] in
            self?.gameResults.append(result)
        }
    }
    
    func sendQuiz() {
        let quizes = gameManager.makeQuiz(quizeNumbers)
        self.quizes = quizes
        self.updateQuize()
        self.gameResults.removeAll()
        
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
        let result = GameResult(userId: "", score: result)
        gameResults.append(result)
//        isMyWin = true
//        showResult.toggle()
        
        Task {
            do {
                try await messenger?.send(result)
            } catch {
                print("can't send")
            }
        }
    }
}
