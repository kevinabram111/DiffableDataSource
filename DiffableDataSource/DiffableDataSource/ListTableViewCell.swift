//
//  InvitedTableViewCell.swift
//  DiffableDataSource
//
//  Created by Kevin Abram on 02/03/23.
//

import UIKit

protocol ListTableViewCellDelegate: AnyObject {
    func didTapActionButton(cellListType: CellListType)
}

class ListTableViewCell: UITableViewCell {
    
    weak var delegate: ListTableViewCellDelegate?
    var cellListType: CellListType?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        
        return button
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
        contentView.addSubview(label)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func build(listType: CellListType, delegate: ListTableViewCellDelegate?) {
        self.cellListType = listType
        switch listType {
        case .list(let name):
            label.text = name
            button.setImage(UIImage.init(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            button.tintColor = UIColor.green
        case .addedList(let name):
            label.text = name
            button.setImage(UIImage.init(systemName: "minus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            button.tintColor = UIColor.red
        case .searchBar:
            break
        }
        self.delegate = delegate
    }
}

// MARK: - @objc functions
extension ListTableViewCell {
    @objc func didTapActionButton() {
        guard let cellListType = cellListType else { return }
        delegate?.didTapActionButton(cellListType: cellListType)
    }
}
