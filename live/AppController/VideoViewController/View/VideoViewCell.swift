//
//  VideoViewCell.swift
//  live
//
//  Created by Maulik Shah on 12/19/24.
//

import UIKit
import AVKit
import Kingfisher
import Lottie

class VideoViewCell: UICollectionViewCell {
    private var playerManager: PlayerManager?
    private var commentsTimer: Timer?
    private var currentCommentIndex: Int = 0
    private var isPlaying: Bool = true
    
    var arrComments : [Comment]? = []
    var keyboardHeight: CGFloat = 0.0
    
    @IBOutlet weak var txtComment: UITextField!
    
    @IBOutlet weak var videoViewBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var stkBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var heartAnimationView: LottieAnimationView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblViewerCount: UILabel!
    @IBOutlet weak var tblComments: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupPlayerManager()
        setupTapGesture()
        setupdoubleTapGesture()
        
        let cells = [CommentCell.self]
        tblComments.register(cellTypes: cells)
        tblComments.showsVerticalScrollIndicator = false
        txtComment.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerManager?.pause()
        playerManager?.cleanup()
        NotificationCenter.default.removeObserver(self)
        stopScrollingComments()
    }

    
    @IBAction func btnSmilePress(_ sender: Any) {
       
    }
}


extension VideoViewCell {
    private func setupPlayerManager() {
        playerManager = PlayerManager()
        playerManager?.playerFinishedPlaying = { [weak self] in
            self?.playerManager?.restart()
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePlayerTap))
        playerView.addGestureRecognizer(tapGesture)
        playerView.isUserInteractionEnabled = true
    }
    
    @objc private func handlePlayerTap() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    private func setupdoubleTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playAnimation))
        tapGesture.numberOfTapsRequired = 2
        playerView.addGestureRecognizer(tapGesture)
        playerView.isUserInteractionEnabled = true
    }
    
    @objc private  func playAnimation(){
        heartAnimationView.animation = LottieAnimation.named("Heart.json")
        heartAnimationView.contentMode = .scaleAspectFit
        heartAnimationView.loopMode = .playOnce
        heartAnimationView.play()
    }
    
    
    func play() {
        playerManager?.play()
        isPlaying = true
    }
    
    func pause() {
        playerManager?.pause()
        isPlaying = false
    }
    
    func playerFinished() {
        playerManager?.restart()
    }
    
    private func scrollToBottom() {
        let lastRow = tblComments.numberOfRows(inSection: tblComments.numberOfSections - 1) - 1
        if lastRow >= 0 {
            let indexPath = IndexPath(row: lastRow, section: tblComments.numberOfSections - 1)
            tblComments.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        commentsTimer?.invalidate()
    }
    
    private func startScrollingComments() {
        stopScrollingComments() // Stop any existing timer
        commentsTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextComment), userInfo: nil, repeats: true)
    }
    
    
    @objc private func scrollToNextComment() {
        guard arrComments?.count ?? 0 > 0 else { return }
        currentCommentIndex = (currentCommentIndex + 1) % (arrComments?.count ?? 0)
        tblComments.scrollToRow(at: IndexPath(row: currentCommentIndex, section: 0), at: .top, animated: true)
    }
    
    func stopScrollingComments() {
        commentsTimer?.invalidate()
        commentsTimer = nil
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
            videoViewBottomConstant.constant = -keyboardHeight
            stkBottomConstant.constant = keyboardHeight
        }
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        
        setBottomConstant()
    }
    
    func setBottomConstant() {
        videoViewBottomConstant.constant = 0
        stkBottomConstant.constant = 0
    }
    
    func configure(info : Video,comments:[Comment]) {
        if let videoUrl = info.videoUrl,let username = info.username,let profileImage = info.profileUrl {
            playerManager?.configurePlayer(with: videoUrl, in: playerView)
           // playerManager?.play()
           
            imgProfile.kf.setImage(
                with: profileImage,
                placeholder: UIImage(named: "ic_user")
            )
            
            lblUserName.text = username
        }
        
        if let topic = info.topic {
            lblTopic.text = topic
        }
        
        if let likes = info.likes {
            lblLikes.text = "\(likes)"
        }
        
        if let views = info.viewers {
            lblViewerCount.text = "\(views)"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.arrComments = comments
            self?.tblComments.reloadData()
            self?.startScrollingComments()
        }
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(keyboardWillShow(_:)),
                                                      name: UIResponder.keyboardWillShowNotification,
                                                      object: nil)
        
        
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(keyboardDidHide(_:)),
                   name: UIResponder.keyboardDidHideNotification,
                   object: nil
               )
        
        setBottomConstant()

    }
}
 

extension VideoViewCell  : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return commentCell(indexPath: indexPath)
    }
    
    func commentCell(indexPath : IndexPath) -> CommentCell {
        let cell = tblComments.dequeueReusableCell(with: CommentCell.self, for: indexPath)
        if let comment = arrComments?[indexPath.row]{
            cell.setupInfo(info:comment)
        }
      
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
}


extension VideoViewCell : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtComment {
            let comment = Comment(id: 0, username: "maulik", picURL: "", comment: textField.text ?? "")
            self.arrComments?.append(comment)
            
            DispatchQueue.main.async {
                self.tblComments.reloadData()
                self.scrollToBottom()
            }
            textField.text = ""
            textField.resignFirstResponder()
        }
        setBottomConstant()
        return true
    }

}

 
