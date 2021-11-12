//
//  SlackAPIService.swift
//  CodingExercise
//
//  Copyright © 2018 slack. All rights reserved.
//

import Foundation

// MARK: - Interfaces

protocol SlackAPIInterface {
  /*
   * Fetches users from search.team API that match the search term
   */
  func fetchUsers(_ searchTerm: String,
                  completionHandler: @escaping (Result<[UserSearchResult], Error>) -> Void)
}

class SlackApi: SlackAPIInterface {
//  private let defaultSession = URLSession(configuration: .default)
  private let defaultSession = URLSession.shared
  private var dataTask: URLSessionDataTask?
  private let baseURLString =  "https://slack-users.herokuapp.com/search"
  /**
   A global shared SlackApi Instance.
   */
  static public let shared: SlackApi = SlackApi()
  
  /**
   Fetch Slack users based on a given search term.

   - parameter searchTerm: A string to match users against.
   - parameter completionHandler: The closure invoked when fetching is completed and the user search results are given.
   */
  func fetchUsers(_ searchTerm: String,
                  completionHandler: @escaping (Result<[UserSearchResult], Error>) -> Void) {
    print("searchterm",searchTerm)

    guard var urlComponents = URLComponents(string: baseURLString) else { return }

    let queryItemQuery = URLQueryItem(name: "query", value: searchTerm)
    urlComponents.queryItems = [queryItemQuery]

    guard let url = urlComponents.url else { return }
    dataTask = defaultSession.dataTask(with: url) { data, response, error in
        // These will be the results we return with our completion handler
      var resultsToReturn = [UserSearchResult]()

      if let error = error {
        print("[API] Request failed with error: \(error.localizedDescription)")
        completionHandler(.failure(error))
        return
      }

      guard let data = data, let response = response as? HTTPURLResponse else {
        completionHandler(.failure("Request returned an invalid response" as! Error))
        return
      }

      guard response.statusCode == 200 else {
        completionHandler(.failure("[API] Request returned an unsupported status code: \(response.statusCode)" as! Error))
        return
      }

      let decoder = JSONDecoder()
      do {
        let result = try decoder.decode(SearchResponse.self, from: data)
        resultsToReturn = result.users
        completionHandler(.success(resultsToReturn))
      } catch {
        completionHandler(.failure("[API] Decoding failed with error: \(error)" as! Error))
      }
    }
    dataTask?.resume()
  }
}
