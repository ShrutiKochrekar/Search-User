//
//  MockUserSearchResultDataProviderInterface.swift
//  CodingExerciseTests
//
//  Created by Shruti Kochrekar on 2021-11-12.
//  Copyright © 2021 slack. All rights reserved.
//

import XCTest
@testable import CodingExercise

class MockUserSearchResultDataProviderInterface: UserSearchResultDataProviderInterface {
  var fetchUserAPISuccessful = true
  var userResult = [UserSearchResult]()
  func fetchUsers(_ searchTerm: String,
                  success: @escaping ([UserSearchResult]) -> Void,
                  failure: @escaping (Error?) -> Void?) {
    if fetchUserAPISuccessful {
      success(userResult)
    } else {
      let error = NSError(domain: "MockUserSearchResultDataProviderInterface",
                          code: 401,
                          userInfo: [NSLocalizedDescriptionKey: "Fetch search results failed"])
      failure(error)
    }
  }
}
