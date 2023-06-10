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
