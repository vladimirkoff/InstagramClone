//
//  SearchController.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 21.03.2023.
//

import UIKit

fileprivate let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {
    //MARK: - Properties
    
    private var users = [User]()
    private var sortedUsers = [User]()
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        fetchUsers()
        configureSearchController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        fetchUsers()
        configureSearchController()
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self // protocol
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    //MARK: - API
    
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
}

//MARK: -  UITableViewDataSource

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? sortedUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? sortedUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? sortedUsers[indexPath.row] : users[indexPath.row]
        let vc = ProfileController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        sortedUsers = users.filter({$0.username.lowercased().contains(searchText) || $0.fullName.lowercased().contains(searchText )})
        tableView.reloadData()
        
    }
}

