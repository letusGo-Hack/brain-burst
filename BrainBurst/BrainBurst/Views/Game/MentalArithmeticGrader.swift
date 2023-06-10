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
    @Published var myRanking: Int = 1
    @Published var gameResults: [GameResult] = [] {
        didSet {
            if gameResults.count == session?.activeParticipants.count {
                let sortedResult = gameResults.sorted {
                    $0.score > $1.score
                }
                let myRanking = sortedResult.firstIndex {
                    $0.userId == UserInfo.uuid
                } ?? 0
                self.myRanking = myRanking + 1
                
                showResult.toggle()
            }
        }
    }
    @Published var showResult: Bool = false

    private var session: GroupSession<GameGroupActivity>?
    
    private var quizes: [Quiz] = []
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
    
    private func makeQuizes() {
        self.quizes = gameManager.makeQuiz(quizeNumbers)
    }
    
    private func updateQuize() {
        guard let newQuize = quizes.first else {
            quiz = "결과: \(result)"
            sendResult()
            return
        }
        startTimer()
        currentQuize = newQuize
    }
    
    func gradeProcess(_ userAnswer: String) -> Bool {
        stopTimer()
        var isAnswer: Bool = false
        let userAnswerConvert = Int(userAnswer) ?? 0
        // true
        if currentQuize != nil {
            if gameManager.checkAnswer(quiz: currentQuize,
                                       userAnswer: userAnswerConvert) {
                result += 1
                isAnswer = true
            }
            if !quizes.isEmpty {
                quizes.removeFirst()
                updateQuize()
            }
        }
        return isAnswer
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
        self.result = 0
        
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
        let result = GameResult(userId: UserInfo.uuid, score: result)
        gameResults.append(result)
        
        Task {
            do {
                try await messenger?.send(result)
            } catch {
                print("can't send")
            }
        }
    }
    
    @Published var timerText: String = "10"
    private var answerTimer: Timer?
    private var seconds: Int = 10 {
        didSet {
            timerText = "\(seconds)"
        }
    }
    private func startTimer() {
        //타이머 사용값 초기화
        //1초 간격 타이머 시작
        if answerTimer != nil, answerTimer!.isValid {
            answerTimer?.invalidate()
        }
        
        answerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        answerTimer?.invalidate()
        answerTimer = nil
        seconds = 10
    }
    
    @objc private func timerCallback() {
        seconds -= 1
        if seconds == 0 {
            _ = quizes.removeFirst()
            stopTimer()
            updateQuize()
        }
    }
}
