//
//  PlayerManger.swift
//  live
//
//  Created by Maulik Shah on 12/20/24.
//

import AVFoundation
import UIKit

class PlayerManager {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerItem: AVPlayerItem?
    
    var playerFinishedPlaying: (() -> Void)?
    
    init() {
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
         
    }
    
    func configurePlayer(with url: URL, in view: UIView) {
        playerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItem)
        
        if let playerLayer = playerLayer {
            playerLayer.videoGravity = .resize
            DispatchQueue.main.async {
                playerLayer.frame = view.bounds
            }
          
            view.layer.addSublayer(playerLayer)
        }
        
        addPlayerObservers()
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func restart() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    private func addPlayerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    @objc private func didFinishPlaying() {
        playerFinishedPlaying?()
    }
    
    func cleanup() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
}
