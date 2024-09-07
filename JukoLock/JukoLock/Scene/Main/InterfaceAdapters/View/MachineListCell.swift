//
//  MachineListCell.swift
//  JukoLock
//
//  Created by 김경호 on 5/17/24.
//

import UIKit

final class MachineListCell: UICollectionViewCell {
    static let id = "MachineListCell"
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "MainColor")
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let machineTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let lastLogLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let machineNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    func setView() {
        self.backgroundColor = UIColor(named: "Side200")
        [ view, lastLogLabel, machineNameLabel ].forEach {
            self.addSubview($0)
        }
        
        view.addSubview(machineTypeImageView)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            view.widthAnchor.constraint(equalToConstant: 32),
            view.heightAnchor.constraint(equalToConstant: 32),
            
            machineTypeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            machineTypeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lastLogLabel.topAnchor.constraint(equalTo: machineTypeImageView.bottomAnchor, constant: 10),
            lastLogLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            lastLogLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            machineNameLabel.topAnchor.constraint(equalTo: lastLogLabel.bottomAnchor, constant: 5),
            machineNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            machineNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        self.backgroundColor = .systemGray4
    }
    
    func setOwnerNameLa(_ owner: String, _ lastLog: String) {
        lastLogLabel.text = lastLog
        machineNameLabel.text = owner
    }
    
    func setData(machine: Machine) {
        machineNameLabel.text = machine.machineName
        lastLogLabel.text = machine.machineLastDay
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
    }
}
