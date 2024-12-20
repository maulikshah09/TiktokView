//
//  VideoViewModel.swift
//  live
//
//  Created by Maulik Shah on 12/19/24.
//

import Foundation

class VideoViewModel {
    private(set) var videos: [Video]? = []
    private(set) var comments: [Comment]? = []

    func loadJSON<T: Decodable>(from fileName: String, as type: T.Type) async throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "\(fileName).json file not found", code: 404, userInfo: nil)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func loadVideos() async throws {
        do {
            let videoModel = try await loadJSON(from: "Videos", as: VideoModel.self)
            if let videos = videoModel.videos {
                self.videos = videos
            } 
        } catch {
            throw error
        }
    }

    func loadComments() async throws {
        do {
            let videoModel = try await loadJSON(from: "Comments", as: CommentModel.self)
            if let comments = videoModel.comments {
                self.comments = comments
            }
        } catch {
            throw error
        }
    }
}
