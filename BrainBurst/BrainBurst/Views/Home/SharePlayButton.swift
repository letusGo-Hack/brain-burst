//
//  SharePlayButton.swift
//  BrainBurst
//
//  Created by 박은비 on 2023/06/10.
//

import SwiftUI

struct SharePlayButton: View {
    
    var actionHandler: ()->Void
    
    var body: some View {
        
        Button(action: actionHandler, label: {
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                
                Image(systemName: "shareplay")
                    .symbolEffect(.pulse)
                    .tint(.white)
            }
            
        })
    }
    
}
