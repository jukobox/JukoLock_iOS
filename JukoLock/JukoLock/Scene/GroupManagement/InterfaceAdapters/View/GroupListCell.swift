//
//  GroupListCell.swift
//  JukoLock
//
//  Created by 김경호 on 8/5/24.
//

import UIKit

final class GroupListCell: UITableViewCell {
    static let id = "GroupListCell"
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder")
    }
    
    func setView() {
        self.addSubview(groupNameLabel)
        
        NSLayoutConstraint.activate([
            groupNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            groupNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
    }
    
    func setGroupName(_ groupName: String) {
        groupNameLabel.text = groupName
    }
}
