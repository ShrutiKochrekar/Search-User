//
//  AutoCompleteTableViewCell.swift
//  CodingExercise
//
//  Created by Shruti Kochrekar on 2021-11-11.
//  Copyright © 2021 slack. All rights reserved.
//

/* This is just representation of how an empty cell will look*/
import Foundation
import UIKit
extension UITableView {
  static let emptyTableViewCell = "EmptyCell"
  func emptyCell(for indexPath: IndexPath) -> UITableViewCell {
    register(UITableViewCell.self, forCellReuseIdentifier: UITableView.emptyTableViewCell)
    return dequeueReusableCell(withIdentifier: UITableView.emptyTableViewCell, for: indexPath)
  }
}
