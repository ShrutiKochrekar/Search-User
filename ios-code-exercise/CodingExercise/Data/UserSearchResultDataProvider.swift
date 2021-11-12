//
//  UsernameSearchResultDataProvider.swift
//  CodingExercise
//
//  Copyright © 2018 slack. All rights reserved.
//

import Foundation

// MARK: - Interfaces
protocol UserSearchResultDataProviderInterface {
  /*
   * Fetches users from that match a given a search term
   */
  func fetchUsers(_ searchTerm: String,
                  success: @escaping ([UserSearchResult]) -> Void,
                  failure: @escaping (Error?)-> Void?)
}

class UserSearchResultDataProvider: UserSearchResultDataProviderInterface {
  var slackAPI: SlackAPIInterface
  
  init(slackAPI: SlackAPIInterface) {
    self.slackAPI = slackAPI
  }
  
  func fetchUsers(_ searchTerm: String,
                  success: @escaping ([UserSearchResult]) -> Void,
                  failure: @escaping (Error?)-> Void?) {
    self.slackAPI.fetchUsers(searchTerm) { result in
      switch result {
      case .success(let users):
        success(users)
      case .failure(let error):
        print("some error", error)
        failure(error)
      }
    }
  }
}
