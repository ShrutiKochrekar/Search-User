//
//  AutoCompleteTableViewCell.swift
//  CodingExercise
//
//  Created by Shruti Kochrekar on 2021-11-11.
//  Copyright © 2021 slack. All rights reserved.
//

/*
 Custom cell which is used to display the search results in the tableview
 */

import Foundation
import UIKit

class AutoCompleteTableViewCell: UITableViewCell {
  static let reuseIdentifier = "AutoCompleteTableViewCell"
  private lazy var userAvatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 4
    return imageView
  }()

  private lazy var userDisplayName: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 29/255.0, green: 28/255.0, blue: 29/255.0, alpha: 1)
    label.font = UIFont(name: "Lato-Bold", size: 16)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    return label
  }()

  private lazy var userName: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 97/255.0, green: 96/255.0, blue: 97/255.0, alpha: 1)
    label.font = UIFont(name: "Lato-Regular", size: 16)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    return label
  }()

  override init(style: UITableViewCell.CellStyle,
                reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    contentView.addSubview(userAvatarImageView)
    contentView.addSubview(userDisplayName)
    contentView.addSubview(userName)
    setUpConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    // function to set up constraints
  private func setUpConstraints() {
    NSLayoutConstraint.activate([
      userAvatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: 16),
      userAvatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 8),
      userAvatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -8),
      userAvatarImageView.widthAnchor.constraint(equalToConstant: 28),
      userAvatarImageView.heightAnchor.constraint(equalTo: userAvatarImageView.widthAnchor),

      userDisplayName.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor,
                                               constant: 12),
      userDisplayName.topAnchor.constraint(equalTo: userAvatarImageView.topAnchor),
      userDisplayName.bottomAnchor.constraint(equalTo: userAvatarImageView.bottomAnchor),

      userName.leadingAnchor.constraint(equalTo: userDisplayName.trailingAnchor,
                                        constant: 8),
      userName.topAnchor.constraint(equalTo: userAvatarImageView.topAnchor),
      userName.bottomAnchor.constraint(equalTo: userAvatarImageView.bottomAnchor),
      userName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                         constant: -16)
    ])
  }

  func configureCell(memberDisplayName: String,
                     memberUserName: String,
                     avatarString: String) {
    userDisplayName.text = memberDisplayName
    userName.text = memberUserName
    guard let imageURL = URL(string: avatarString),
          let imageData = try? Data(contentsOf: imageURL) else {
            return
          }
    userAvatarImageView.image = UIImage(data: imageData)
    layoutIfNeeded()
  }
}
