//
//  MediaHandler.swift
//  MediaApp
//
//  Created by Vineesh
//  Copyright © 2018 Media. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaHandler: NSObject {

    static let instance =  MediaHandler()
    
    var musicPlayerManager = MusicPlayerManager()
    
     func fetchAllSongs(completion:@escaping(_ reusult:[MPMediaItem]?)->Void){
       // let mediaQuery = MPMediaQuery()
        let songList = MPMediaQuery.songs().items
        completion(songList)
    }
    
}
