//
//  Utils.swift
//  BrainBurst
//
//  Created by 고대원 on 2023/06/10.
//

import Foundation
import SwiftUI

struct IsVisibleModifier : ViewModifier{
   
   var isVisible : Bool
   var transition : AnyTransition
   
   func body(content: Content) -> some View {
       ZStack{
           if isVisible {
               content.transition(transition)
           }
       }
   }
}

extension View {
   
   func isVisible(
       isVisible : Bool,
       transition : AnyTransition = .scale
   ) -> some View{
       modifier(
           IsVisibleModifier(
               isVisible: isVisible,
               transition: transition
           )
       )
       
       
   }
}
