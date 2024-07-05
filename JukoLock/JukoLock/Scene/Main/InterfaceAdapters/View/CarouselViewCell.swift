//
//  CarouselViewCell.swift
//  JukoLock
//
//  Created by 김경호 on 7/1/24.
//

import UIKit

final class CarouselViewCell: UICollectionViewCell {
    static let id = "CarouselViewCell"
    
    private let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "김경호 집 도어락"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastLog: UILabel = {
        let label = UILabel()
        label.text = "2024.07.02" // 추후 삭제
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.view)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.lastLog)
        
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            self.nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            self.lastLog.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
            self.lastLog.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor)
        ])
    }
    
    func setData(name: String, log: String) {
        self.nameLabel.text = name
        self.lastLog.text = log
    }
}
