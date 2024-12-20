//
//  VideoModel.swift
//  live
//
//  Created by Maulik Shah on 12/19/24.
//

import Foundation

struct VideoModel : Decodable {
    let videos: [Video]?
}

struct Video : Decodable{
    let id, userID,viewers,likes: Int?
    let username, profilePicURL, description, topic, video, thumbnail: String?
    
    var profileUrl : URL?{
        guard let profilePicURL else { return nil }
        return URL(string:  profilePicURL)
    }
    
    var videoUrl : URL?{
        guard let video else { return nil }
        return URL(string:  video)
    }
}
