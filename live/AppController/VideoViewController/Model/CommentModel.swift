//
//  CommentModel.swift
//  live
//
//  Created by Maulik Shah on 12/19/24.
//

import Foundation

struct CommentModel : Decodable{
    var comments: [Comment]?
}


struct Comment : Decodable{
    var id: Int?
    var username, picURL, comment: String?
    
    var profileUrl : URL?{
        guard let picURL else { return nil }
        return URL(string:  picURL)
    }
}
