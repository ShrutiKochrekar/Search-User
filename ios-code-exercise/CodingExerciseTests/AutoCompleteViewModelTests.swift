//
//  AutoCompleteViewModelTests.swift
//  CodingExerciseTests
//
//  Created by Shruti Kochrekar on 2021-11-12.
//  Copyright © 2021 slack. All rights reserved.
//

import XCTest
@testable import CodingExercise

class AutoCompleteViewModelTests: XCTestCase {
  private var mockUserSearchResultDataProvider: MockUserSearchResultDataProviderInterface!
  private var sut: AutoCompleteViewModel!
  private var testUserResult: [UserSearchResult]!

  override func setUp() {
    super.setUp()
    mockUserSearchResultDataProvider = MockUserSearchResultDataProviderInterface()
    testUserResult = createTestdata()
    sut = AutoCompleteViewModel(dataProvider: mockUserSearchResultDataProvider)
  }

  override func tearDown() {
    sut = nil
    mockUserSearchResultDataProvider = nil
    super.tearDown()
  }

  func testUpdateSearchText() {
    let searchText = "b"
    mockUserSearchResultDataProvider.userResult = testUserResult
    mockUserSearchResultDataProvider.fetchUserAPISuccessful = true
    sut.updateSearchText(text: searchText)
    if let usersFromCache = sut.localCache[searchText] {
      XCTAssertEqual(testUserResult.count, usersFromCache.count)
    } else {
      XCTFail("Value not found in local cache")
    }
  }

  func testUpdateSearchTextFailure() {
    let searchText = "b"
    mockUserSearchResultDataProvider.fetchUserAPISuccessful = false
    sut.updateSearchText(text: searchText)
    XCTAssertEqual(sut.userSearchResult.count, 0)
  }

  func testDeniedListUpdated() {
    let searchText = "ci9"
    mockUserSearchResultDataProvider.fetchUserAPISuccessful = true
    sut.updateSearchText(text: searchText)
    XCTAssertTrue(sut.checkDeniedListFor(searchText))
  }

  func testUserResultValues() {
    sut.userSearchResult = testUserResult
    XCTAssertEqual(sut.userNamesCount(), 3)
    XCTAssertEqual(sut.userName(at: 0), "bhuffman")
    XCTAssertEqual(sut.userDisplayName(at: 0), "Brooklyn Huffman")
    XCTAssertEqual(sut.userImage(at: 0), "https://randomuser.me/api/portraits/women/52.jpg")
  }

  func testCheckValueInDeniedList() {
    let searchText = "ci"
    sut.deniedList.append(searchText)
    sut.updateSearchText(text: searchText)
    XCTAssertEqual(sut.userSearchResult.count, 0)
  }

  func testUpdateResultsFromAPI() {
    let searchText = "b"
    sut.updateResultsFromAPISuccess(searchText, users: testUserResult)
    XCTAssertEqual(sut.userSearchResult.count, 3)
  }

  func testUpdateResultsFromAPINoUsers() {
    let searchText = "ci"
    sut.updateResultsFromAPISuccess(searchText, users: [UserSearchResult]())
    XCTAssertEqual(sut.userSearchResult.count, 0)
  }
}

extension AutoCompleteViewModelTests {
  func createTestdata() -> [UserSearchResult] {
    let user1 = UserSearchResult(username: "bhuffman",
                                 avatarUrl: "https://randomuser.me/api/portraits/women/52.jpg",
                                 id: 1,
                                 displayName: "Brooklyn Huffman")
    let user2 = UserSearchResult(username: "bjames",
                                 avatarUrl: "https://randomuser.me/api/portraits/women/52.jpg",
                                 id: 46,
                                 displayName: "Braden James")
    let user3 = UserSearchResult(username: "bbooker",
                                 avatarUrl: "https://randomuser.me/api/portraits/women/52.jpg",
                                 id: 73,
                                 displayName: "Bronson Booker")
    let userResult = [user1, user2, user3]
    return userResult
  }
}
