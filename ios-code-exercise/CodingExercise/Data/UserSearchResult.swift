//
//  UserSearchResult.swift
//  CodingExercise
//
//  Copyright © 2018 slack. All rights reserved.
//

import Foundation
/* UserSearchResult will have teh following values as example
 {
     "avatar_url": "https://randomuser.me/api/portraits/women/52.jpg",
     "display_name": "Brooklyn Huffman",
     "id": 1,
     "username": "bhuffman"
   }
 */
struct UserSearchResult: Codable {
  let username: String
  let avatarUrl: String
  let id: Int
  let displayName: String
  
  enum CodingKeys: String, CodingKey {
    case avatarUrl = "avatar_url"
    case displayName = "display_name"
    case username, id
  }
}

struct SearchResponse: Codable {
    let ok: Bool
    let error: String?
    let users: [UserSearchResult]
}
