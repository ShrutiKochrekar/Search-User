//
//  AutoCompleteViewModel.swift
//  CodingExercise
//
//  Copyright © 2018 slack. All rights reserved.
//

import Foundation

protocol AutoCompleteViewModelDelegate: class {
  func usersDataUpdated()
  func displayNoUserFoundLabelFor(_ string: String)
}

// MARK: - Interfaces
protocol AutoCompleteViewModelInterface {
  /*
   * Fetches users from that match a given a search term
   */
    //  func fetchUserNames(_ searchTerm: String?, completionHandler: @escaping ([UserSearchResult]) -> Void)

  /*
   * Updates usernames according to given update string.
   */
  func updateSearchText(text: String?)

  /*
   * Returns a username at the given position.
   */
  func userName(at index: Int) -> String

  /*
   * Returns a displayName at the given position.
   */
  func userDisplayName(at index: Int) -> String

  /*
   * Returns a user avatar url string at the given position.
   */
  func userImage(at index: Int) -> String
  /*
   * Returns the count of the current usernames array.
   */
  func userNamesCount() -> Int

  /*
   * Get the strings in the denied list
   */
  func getDeniedList()

  /*
   Delegate that allows to send data updates through callback.
   */
  var delegate: AutoCompleteViewModelDelegate? { get set }
}

class AutoCompleteViewModel: AutoCompleteViewModelInterface {
  private let resultsDataProvider: UserSearchResultDataProviderInterface
  public weak var delegate: AutoCompleteViewModelDelegate?

  // exposed for testing
  var localCache = [String: [UserSearchResult]]()
  var deniedList = [String]()
  var userSearchResult = [UserSearchResult]()
  
  init(dataProvider: UserSearchResultDataProviderInterface) {
    self.resultsDataProvider = dataProvider
  }
  
  func updateSearchText(text: String?) {
    guard let checkString = text else {
      return
    }
    if checkDeniedListFor(checkString) {
      self.userSearchResult.removeAll()
      self.delegate?.displayNoUserFoundLabelFor(checkString)
    } else {
      self.fetchUserNames(checkString) { [weak self] users in
        DispatchQueue.main.async {
          guard let self = self else {
            return
          }
          self.updateResultsFromAPISuccess(checkString, users: users)
        }
      }
    }
  }

  func updateResultsFromAPISuccess(_ string: String,
                                   users: [UserSearchResult]) {
    if users.isEmpty {
      delegate?.displayNoUserFoundLabelFor(string)
    } else {
      userSearchResult = users
      delegate?.usersDataUpdated()
    }
  }

  func userNamesCount() -> Int {
    return userSearchResult.count
  }
  
  func userName(at index: Int) -> String {
    return userSearchResult[index].username
  }
  
  func userDisplayName(at index: Int) -> String {
    return userSearchResult[index].displayName
  }
  func userImage(at index: Int) -> String {
    return userSearchResult[index].avatarUrl
  }
  
  func fetchUserNames(_ searchTerm: String,
                      completionHandler: @escaping ([UserSearchResult]) -> Void) {
      // check if the searcg string is present in the cache
    if let usersFromCache = localCache[searchTerm] {
      completionHandler(usersFromCache)
    } else {
        // search string is not present in cache so make API call
      self.resultsDataProvider.fetchUsers(searchTerm) { [weak self] users in
        guard let self = self else {
          return
        }
        if users.isEmpty {
            // the search string returned empty response -> update the denied txt
          self.updateDeniedList(searchTerm)
        }
          // update local cache for persistency
        self.updateLocalCacheWith(text: searchTerm, result: users)
        completionHandler(users)
      } failure: { error in
        print("Service failure")
      }
    }
  }

  /* The function updates the cache with the API values*/
  func updateLocalCacheWith(text: String,
                            result: [UserSearchResult]) {
    localCache[text] = result
  }
  
    // MARK: - Denied list methods
  func getDeniedList() {
    if let path = Bundle.main.path(forResource: "denylist", ofType: "txt") {
      do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        deniedList = data.components(separatedBy: .newlines)
      } catch {
        print("Error in reading the denied file")
      }
    }
  }
  
  func updateDeniedList(_ string: String) {
    deniedList.append(string)
  }
  
  func checkDeniedListFor(_ string: String) -> Bool {
    if deniedList.contains(string.lowercased()) {
      return true
    }
    return false
  }
}
