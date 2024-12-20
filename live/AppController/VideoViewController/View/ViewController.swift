//
//  ViewController.swift
//  live
//
//  Created by Maulik Shah on 12/19/24.
//

import UIKit

class ViewController: UIViewController {
    let viewModel = VideoViewModel()

    @IBOutlet weak var cvCollectionView: UICollectionView!
    private var currentlyPlayingIndex :  IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


// MARK: - Setup Functions
extension ViewController {
    func setup() {
        let cell = [VideoViewCell.self]
        cvCollectionView.register(cellTypes: cell)
    
        Task{
            do {
                try await viewModel.loadVideos()
                try await viewModel.loadComments()
        
                self.cvCollectionView.reloadData()
                
                
                // Ensure playback starts for the first visible video
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playFirstVisibleVideo()
                }
                
            } catch {
                print("Failed to load data: \(error)")
            }
        }
    }
    
    private func playFirstVisibleVideo() {
        guard let firstIndex = findPerfectVisibleIndex() else { return }
        playVideo(at: firstIndex)
    }
}

// MARK: - collectionview methods.
extension ViewController :UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return videoView(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if let cell = cell as? VideoViewCell,let  currentlyPlayingIndex = currentlyPlayingIndex {
            if currentlyPlayingIndex != indexPath {
               
                if let currentIndex = self.currentlyPlayingIndex,
                   let currentCell = collectionView.cellForItem(at: currentIndex) as? VideoViewCell {
                    currentCell.pause()
                }
                
                self.currentlyPlayingIndex = indexPath
                cell.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? VideoViewCell {
            cell.pause()
            
            if currentlyPlayingIndex == indexPath {
                currentlyPlayingIndex = nil
            }
        }
    }
    
    func videoView(indexPath: IndexPath) -> VideoViewCell {
        let cell =  cvCollectionView.dequeueReusableCell(with: VideoViewCell.self, for: indexPath)
        if let video = viewModel.videos?[indexPath.row],let comments = viewModel.comments {
            cell.configure(info: video,comments: comments)
        }
        
        return cell
    }
}



extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let perfectIndex = findPerfectVisibleIndex() {
            playVideo(at: perfectIndex)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if let perfectIndex = findPerfectVisibleIndex() {
                playVideo(at: perfectIndex)
            }
        }
    }

    private func playVideo(at indexPath: IndexPath) {
        if currentlyPlayingIndex != indexPath {
            if let currentIndex = currentlyPlayingIndex,
               let currentCell = cvCollectionView.cellForItem(at: currentIndex) as? VideoViewCell {
                currentCell.pause()
            }

            if let newCell = cvCollectionView.cellForItem(at: indexPath) as? VideoViewCell {
                newCell.play()
                currentlyPlayingIndex = indexPath
            }
        }
    }
    
    private func findPerfectVisibleIndex() -> IndexPath? {
        guard let collectionView = cvCollectionView else { return nil }

        let visibleCells = collectionView.visibleCells
        var maxVisibleArea: CGFloat = 0
        var perfectIndex: IndexPath?

        for cell in visibleCells {
            if let indexPath = collectionView.indexPath(for: cell),
               let attributes = collectionView.layoutAttributesForItem(at: indexPath) {
                
                let visibleFrame = collectionView.bounds.intersection(attributes.frame)
                let visibleArea = visibleFrame.width * visibleFrame.height
    
                if visibleArea > maxVisibleArea {
                    maxVisibleArea = visibleArea
                    perfectIndex = indexPath
                }
            }
        }
        return perfectIndex
    }
}
