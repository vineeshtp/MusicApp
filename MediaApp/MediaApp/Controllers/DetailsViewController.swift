//
//  DetailsViewController.swift
//  MediaApp
//
//  Created by Vineesh
//  Copyright © 2018 Media. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailsViewController: UIViewController {

    var currentPlayingItem:MPMediaItem?
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var prevButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var slider: UISlider!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the notification observer needed to respond to events from the `MusicPlayerManager`.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMusicPlayerManagerDidUpdateState),
                                               name: MusicPlayerManager.didUpdateState,
                                               object: nil)
        
        updatePlaybackControls()
        updateCurrentItemMetadata()
        
        self.setSongDetails()
        
        self.updateNowPlayingInfo()
        
        
       // let token = MediaHandler.instance.musicPlayerManager.musicPlayerController.
//        let interval = CMTimeMake(1, 1)
//       let timeObserverToken = MediaHandler.instance.musicPlayerManager.musicPlayerController.addPeriodicTimeObserver(forInterval:interval, queue: DispatchQueue.main) { [unowned self] time in
//
////            let timeElapsed = Float(CMTimeGetSeconds(time))
////            self.custSlider.value = Float(timeElapsed)
////            self.minTimeLabel.text = self.createTimeString(time: timeElapsed)
////            let remainingTimer = sliderMaxVal - timeElapsed
////            self.remainingTimeLabel.text = self.createTimeString(time: remainingTimer)
//        }
        
        /*
        
        custSlider.isContinuous = true
        
        let interval = CMTimeMake(1, 1)
        timeObserverToken = tempPlayer.addPeriodicTimeObserver(forInterval:interval, queue: DispatchQueue.main) { [unowned self] time in
            
            let timeElapsed = Float(CMTimeGetSeconds(time))
            self.custSlider.value = Float(timeElapsed)
            self.minTimeLabel.text = self.createTimeString(time: timeElapsed)
            let remainingTimer = sliderMaxVal - timeElapsed
            self.remainingTimeLabel.text = self.createTimeString(time: remainingTimer)
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        // Remove all notification observers.
        NotificationCenter.default.removeObserver(self,
                                                  name: MusicPlayerManager.didUpdateState,
                                                  object: nil)
    }
    
    
    
    func setSongDetails() {
        
        self.titleLabel.text = currentPlayingItem?.albumTitle
        self.artistLabel.text = currentPlayingItem?.artist
        self.imgView.image = currentPlayingItem?.artwork?.image(at: self.imgView.frame.size)
        
    }
    func updateNowPlayingInfo(){
        
        self.slider.maximumValue = Float((currentPlayingItem?.playbackDuration)!)
        self.slider.minimumValue = 0
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
        
    }
    @objc func timerFired(_:AnyObject){
        if let nowPlayingItem = MediaHandler.instance.musicPlayerManager.musicPlayerController.nowPlayingItem {
            
            let trackDuration = nowPlayingItem.playbackDuration
            self.slider.maximumValue = Float(trackDuration)
            
            let trackElapsed = MediaHandler.instance.musicPlayerManager.musicPlayerController.currentPlaybackTime
            
            self.slider.value = Float(trackElapsed)
            
        }
    }
    
    
    // MARK: Notification Observing Methods
    
    @objc func handleMusicPlayerManagerDidUpdateState() {
        DispatchQueue.main.async {
            self.updatePlaybackControls()
            self.updateCurrentItemMetadata()
        }
    }
    
    // MARK: UI Update Methods
    
    func updatePlaybackControls() {
        
        let playbackState = MediaHandler.instance.musicPlayerManager.musicPlayerController.playbackState
        
        switch playbackState {
        case .interrupted, .paused, .stopped:
            playButton.setTitle("Play", for: .normal)
        case .playing:
            playButton.setTitle("Pause", for: .normal)
        default:
            break
        }
        
        if playbackState == .stopped {
            prevButton.isEnabled = false
            playButton.isEnabled = false
            nextButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
            playButton.isEnabled = true
            nextButton.isEnabled = true
        }
        
        updateCurrentItemMetadata()
        
    }
    func updateCurrentItemMetadata() {
        if let nowPlayingItem = MediaHandler.instance.musicPlayerManager.musicPlayerController.nowPlayingItem {
            
            self.imgView.image = nowPlayingItem.artwork?.image(at: self.imgView.frame.size)
             titleLabel.text = nowPlayingItem.albumTitle
            artistLabel.text = nowPlayingItem.artist
            
            
             let trackDuration = nowPlayingItem.playbackDuration
            self.slider.maximumValue = Float(trackDuration)
            
            let trackElapsed = MediaHandler.instance.musicPlayerManager.musicPlayerController.currentPlaybackTime
            
            self.slider.value = Float(trackElapsed)
            
            
        } else {
            self.imgView.image = nil
            titleLabel.text = "No Item Playing"
            artistLabel.text = " "
        }
    }
    @IBAction func didPressPlay(_ sender: UIButton) {
        MediaHandler.instance.musicPlayerManager.togglePlayPause()
    }
    
    
    @IBAction func didPressPrevious(_ sender: UIButton) {
         MediaHandler.instance.musicPlayerManager.skipBackToBeginningOrPreviousItem()
    }
    
    @IBAction func didPressNext(_ sender: UIButton) {
        MediaHandler.instance.musicPlayerManager.skipToNextItem()
    }
    
    @IBAction func sliderPressed(_ sender: UISlider) {
        MediaHandler.instance.musicPlayerManager.musicPlayerController.currentPlaybackTime = TimeInterval(self.slider.value)
    }
    
}

