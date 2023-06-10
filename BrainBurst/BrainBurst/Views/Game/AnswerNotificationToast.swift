//
//  AnswerNotificationToast.swift
//  Common
//
//  Created by 박은비 on 2023/06/10.
//

import SwiftUI

struct AnswerNotificationToast: View {
    
    enum Result {
        case correct
        case wrong
        
        var imageNamed: String {
            switch self {
            case .correct:
                return "circle.circle"
            case .wrong:
                return "xmark"
            }
        }
        
        var color: Color {
            switch self {
            case .correct:
                return .green
            case .wrong:
                return .red
            }
        
        }
    }
    
    @Binding var isHidden : Bool
    var result : Result
    
    var body: some View {
        Image(systemName: result.imageNamed)
            .resizable()
            .frame(width: 300, height: 300)
            .foregroundColor(result.color)
            .symbolEffect(.pulse)
            .isVisible(isVisible: isHidden)
        
    }
}


 

// MARK: - Sample Code
//struct ContentView: View {
//    
//    @State private var isShowAnswer: Bool = false
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                
//                Text("Hello, world!")
//                Button(action: {
//                    print("test")
//                    showAnswerNotification()
//                }, label: {
//                    Text("Button")
//                })
//                
//            }
//            .padding()
//            
//            AnswerNotificationToast(isHidden: $isShowAnswer, result: .correct)
//            
//            
//        }
//    }
//    
//    private func showAnswerNotification() {
//        isShowAnswer = true
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//            withAnimation(.easeInOut) {
//                isShowAnswer = false
//            }
//        }
//    }
//}

