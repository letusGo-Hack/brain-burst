//
//  GameManager.swift
//  BrainBurst
//
//  Created by J_Min on 2023/06/10.
//

import Foundation

final class GameManager {
    
    private var quizMaker: QuizMaker
    
    init(maker: QuizMaker) {
        self.quizMaker = maker
    }
    
    func makeQuiz(_ count: Int) -> [Quiz] {
        var quizs: [Quiz] = []
        for _ in 0..<count {
            let quiz = quizMaker.makeQuiz()
            quizs.append(quiz)
        }
        return quizs
    }
    
    func checkAnswer(quiz: Quiz, userAnswer: Int) -> Bool {
        return userAnswer == quiz.answer
    }
}
