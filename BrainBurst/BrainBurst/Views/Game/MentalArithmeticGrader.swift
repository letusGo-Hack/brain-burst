//
//  MentalArithmeticGrader.swift
//  BrainBurst
//
//  Created by todoc on 2023/06/10.
//

import Foundation

final class MentalArithmeticGrader: ObservableObject {
    @Published var quiz: String = ""
    @Published var answer: Int = 0

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
    
    func viewLoaded() {
        makeQuizes()
        updateQuize()
    }
    
    private func makeQuizes() {
        self.quizes = gameManager.makeQuiz(quizeNumbers)
    }
    
    private func updateQuize() {
        guard let newQuize = quizes.first else {
            quiz = "결과: \(result)"
            return
        }
        currentQuize = newQuize
    }
    
    func gradeProcess(_ userAnswer: String) {
        
        let userAnswerConvert = Int(userAnswer) ?? 0
        // true
        if gameManager.checkAnswer(quiz: currentQuize,
                                   userAnswer: userAnswerConvert) {
            result += 1
        }
        _ = quizes.removeFirst()
        updateQuize()
    }
}
