//
//  AutoCompleteViewControllerswift
//  CodingExercise
//
//  Copyright © 2018 slack. All rights reserved.
//

import UIKit

struct Constants {
    static let textFieldPlaceholder = "Search"
    static let cellRowHeight: CGFloat = 50.0
    static let leftSpacing: CGFloat = 20.0
    static let bottomSpacing: CGFloat = 20.0
    static let rightSpacing: CGFloat = -20.0
}

class AutoCompleteViewController: UIViewController {
  private var viewModel: AutoCompleteViewModelInterface
  
  private lazy var noUserFoundLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = UIFont(name: "Lato-Bold", size: 16)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    label.text = "No users found"
    return label
  }()
  
  private lazy var searchTextField: UITextField = {
    let textField = UITextField(frame: .zero)
    textField.placeholder = Constants.textFieldPlaceholder
    textField.accessibilityLabel = Constants.textFieldPlaceholder
    textField.borderStyle = .roundedRect
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private lazy var searchResultsTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = Constants.cellRowHeight
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(AutoCompleteTableViewCell.self,
                       forCellReuseIdentifier: AutoCompleteTableViewCell.reuseIdentifier)
    return tableView
  }()
  
  private lazy var contentView: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  init(viewModel: AutoCompleteViewModelInterface) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchTextField.delegate = self
    searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    
    searchResultsTableView.dataSource = self
    searchResultsTableView.delegate = self
    
    viewModel.delegate = self
    viewModel.getDeniedList()
    setupSubviews()
  }
  
  private func setupSubviews() {
    contentView.addSubview(searchTextField)
    contentView.addSubview(searchResultsTableView)
    contentView.addSubview(noUserFoundLabel)
    view.addSubview(contentView)
    
    noUserFoundLabel.isHidden = true
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
      contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
      contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      contentView.heightAnchor.constraint(equalToConstant: view.frame.height/2),
      
      searchTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
      searchTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.leftSpacing),
      searchTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Constants.rightSpacing),
      
      searchResultsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Constants.bottomSpacing),
      searchResultsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      searchResultsTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.leftSpacing),
      searchResultsTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Constants.rightSpacing)
    ])
    
    NSLayoutConstraint.activate([
      noUserFoundLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor,
                                            constant: Constants.bottomSpacing),
      noUserFoundLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                             constant: Constants.leftSpacing),
      noUserFoundLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                              constant: Constants.rightSpacing)
    ])
  }
}

extension AutoCompleteViewController: UITextFieldDelegate {
  @objc func textFieldDidChange(textField: UITextField) {
    viewModel.updateSearchText(text: searchTextField.text)
  }
}

extension AutoCompleteViewController: AutoCompleteViewModelDelegate {
  func usersDataUpdated() {
    searchResultsTableView.isHidden = false
    noUserFoundLabel.isHidden = true
    searchResultsTableView.reloadData()
  }

  func displayNoUserFoundLabelFor(_ string: String) {
    if !string.isEmpty {
      noUserFoundLabel.isHidden = false
      searchResultsTableView.reloadData()
      view.layoutIfNeeded()
      updateViewConstraints()
    } else {
      noUserFoundLabel.isHidden = true
    }
    searchResultsTableView.isHidden = true
  }
}

extension AutoCompleteViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AutoCompleteTableViewCell.reuseIdentifier,
                                                   for: indexPath) as? AutoCompleteTableViewCell else {
      return tableView.emptyCell(for: indexPath)
    }
    let userName = viewModel.userName(at: indexPath.row)
    let displayName = viewModel.userDisplayName(at: indexPath.row)
    let imageUrlString = viewModel.userImage(at: indexPath.row)
    cell.configureCell(memberDisplayName: displayName,
                       memberUserName: userName,
                       avatarString: imageUrlString)

    cell.accessibilityLabel = userName
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.userNamesCount()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
}
