//
//  MachineListCell.swift
//  JukoLock
//
//  Created by 김경호 on 5/17/24.
//

import UIKit

final class MachineListCell: UICollectionViewCell {
    static let id = "MachineListCell"
    
    let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
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
        addSubview(imgView)
        addSubview(label)
        imgView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 19).isActive = true
        label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15).isActive = true
    }
    func setImageandLabel(imgName: String, text: String) {
//        imgView.image = UIImage(named: imgName)
        imgView.image = UIImage(systemName: "lock.open.fill")
        label.text = text
    }
    func setData() {
        self.setImageandLabel(imgName: "TestImage", text: "test")
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
    }
}
