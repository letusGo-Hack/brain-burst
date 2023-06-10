//
//  GameQuizeView.swift
//  BrainBurst
//
//  Created by todoc on 2023/06/10.
//

import SwiftUI

struct QuizGameView: View {
    
    @State var quizText: String = "Quiz"
    @State var userAnswer: String = ""
    @ObservedObject var grader: MentalArithmeticGrader    
    
    init(grader: MentalArithmeticGrader) {
        self.grader = grader
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(grader.quiz)
                .font(.title)
            Spacer()
            TextField("Enter Answer", text: $userAnswer)
                .multilineTextAlignment(.center)
            Text("확인용 답: \(grader.answer)")
            Spacer()
            Button("Next") {
                grader.gradeProcess(userAnswer)
                userAnswer = ""
            }
            Spacer()
        }.onAppear {
            grader.viewLoaded()
        }
        .background()
    }
}

struct QuizGameView_Previews: PreviewProvider {
    static var previews: some View {
        let maker = MentalArithmeticQuizMaker()
        let gameManager = GameManager(maker: maker)
        let grader = MentalArithmeticGrader(gameManager: gameManager)
        return QuizGameView(grader: grader)
    }
}
