//
//  SearchBarTableViewCell.swift
//  DiffableDataSource
//
//  Created by Kevin Abram on 02/03/23.
//

import UIKit

protocol SearchBarTableViewCellDelegate: AnyObject {
    func didSearch(text: String)
}

class SearchBarTableViewCell: UITableViewCell {
    
    weak var delegate: SearchBarTableViewCellDelegate?
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        
        return searchBar
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    func didInit() {
        selectionStyle = .none
        backgroundColor = .clear
        layoutViews()
    }
    
    func layoutViews() {
        contentView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension SearchBarTableViewCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didSearch(text: searchText)
    }
}
