//
//  CommentCell.swift
//  live
//
//  Created by Maulik Shah on 12/19/24.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblUserName.font = AppFont.semiBold.of(9)
        lblComment.font = AppFont.medium.of(9)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupInfo (info : Comment){
        if let profileImage = info.profileUrl {
            imgProfile.kf.setImage(
                with: profileImage,
                placeholder: UIImage(named: "ic_user")
            )
        }else{
            imgProfile.image = UIImage(named: "ic_user")
        }
        
        if let username = info.username,let comment = info.comment {
            lblUserName.text = username
            lblComment.text = comment
        }
    }
}
