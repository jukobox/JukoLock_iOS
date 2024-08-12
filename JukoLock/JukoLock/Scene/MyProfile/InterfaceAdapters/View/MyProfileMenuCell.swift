//
//  MyProfileMenuCell.swift
//  JukoLock
//
//  Created by 김경호 on 7/5/24.
//

import UIKit

final class MyProfileMenuCell: UITableViewCell {
    static let id = "MyProfileMenuCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        self.addSubview(iconView)
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10)
        ])
    }
    
    func setMenuName(_ name: String, _ image: String) {
        nameLabel.text = name
        iconView.image = UIImage(systemName: image)
    }
}
