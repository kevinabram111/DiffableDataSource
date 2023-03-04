//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by Kevin Abram on 02/03/23.
//

import UIKit

enum CellSectionType: Hashable {
    case searchBar
    case addedList
    case list
}

enum CellListType: Hashable {
    case searchBar
    case addedList(name: String)
    case list(name: String)
}

class ViewController: UIViewController {
    
    var addedListDictionary: [String: String] = [:]
    var addedList: [CellListType] = []
    var list: [CellListType] = []
    var searchText: String = ""
    
    let fullList: [CellListType] = [
        .list(name: "Lily Rose"),
        .list(name: "Ava Grace"),
        .list(name: "Ruby Mae"),
        .list(name: "Stella Luna"),
        .list(name: "Jack Ryan"),
        .list(name: "Emma Kate"),
        .list(name: "Olivia Jade"),
        .list(name: "Ethan James"),
        .list(name: "Amelia Rose"),
        .list(name: "Lucas John"),
        .list(name: "Madison Claire"),
        .list(name: "Noah William"),
        .list(name: "Isla Faith"),
        .list(name: "Mason Alexander"),
        .list(name: "Grace Elizabeth"),
        .list(name: "Liam Thomas"),
        .list(name: "Chloe Grace"),
        .list(name: "Jackson Lee"),
        .list(name: "Scarlett Belle")
    ]
    
    var snapShot = NSDiffableDataSourceSnapshot<CellSectionType, CellListType>()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListTableViewCell")
        tableView.register(SearchBarTableViewCell.self, forCellReuseIdentifier: "SearchBarTableViewCell")
        tableView.backgroundColor = .clear
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        list = fullList
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapScreen)))
        
        tableView.dataSource = dataSource
        refreshSnapShot()
    }
    
    lazy var dataSource = UITableViewDiffableDataSource<CellSectionType, CellListType>.init(
        tableView: tableView,
        cellProvider: { [weak self] tableView, indexPath, cellType in
            guard let self = self else { return UITableViewCell() }
            return self.setupDataSource(tableView, indexPath, cellType)
        }
    )
}

extension ViewController: UITableViewDelegate {
    func refreshSnapShot() {
        snapShot = NSDiffableDataSourceSnapshot<CellSectionType, CellListType>()
        snapShot.appendSections([.addedList, .searchBar, .list])
        snapShot.appendItems(addedList, toSection: .addedList)
        snapShot.appendItems([.searchBar], toSection: .searchBar)
        snapShot.appendItems(list, toSection: .list)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    func setupDataSource(_ tableView: UITableView, _ indexPath: IndexPath, _ cellListType: CellListType) -> UITableViewCell {
        switch cellListType {
        case .searchBar:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarTableViewCell", for: indexPath) as! SearchBarTableViewCell
            cell.delegate = self
            return cell
        case .addedList, .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            cell.build(listType: cellListType, delegate: self)
            return cell
        }
    }
}

extension ViewController: SearchBarTableViewCellDelegate {
    func didSearch(text: String) {
        searchText = text
        if text.isEmpty {
            list = fullList.filter({ cellListType in
                switch cellListType {
                case .searchBar, .addedList:
                    return false
                case .list(let name):
                    return addedListDictionary[name] == nil
                }
            })
        } else {
            list = fullList.filter({ cellListType in
                switch cellListType {
                case .searchBar, .addedList:
                    return false
                case .list(let name):
                    return name.lowercased().contains(text.lowercased()) && addedListDictionary[name] == nil
                }
            })
        }
        refreshSnapShot()
    }
}

extension ViewController: ListTableViewCellDelegate {
    func didTapActionButton(cellListType: CellListType) {
        switch cellListType {
        case .searchBar:
            break
        case .addedList(let name):
            if let index = snapShot.indexOfItem(cellListType) {
                addedList.remove(at: index)
                snapShot.deleteItems([cellListType])
                let newPerson: CellListType = .list(name: name)
                if name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty {
                    snapShot.appendItems([newPerson], toSection: .list)
                }
                addedListDictionary.removeValue(forKey: name)
                list.append(newPerson)
            }
        case .list(let name):
            if let index = snapShot.indexOfItem(cellListType) {
                list.remove(at: index - addedList.count - 1)
                snapShot.deleteItems([cellListType])
                let newPerson: CellListType = .addedList(name: name)
                snapShot.appendItems([newPerson], toSection: .addedList)
                addedListDictionary[name] = name
                addedList.append(newPerson)
            }
        }
        dataSource.apply(snapShot)
    }
}

extension ViewController {
    @objc func didTapScreen() {
        view.endEditing(true)
    }
}
