//
//  MachineLogTableViewCell.swift
//  JukoLock
//
//  Created by 김경호 on 9/7/24.
//

import UIKit

final class MachineLogTableViewCell: UITableViewCell {
    static let id = "MachineLogTableViewCell"

    private let logLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("coder")
    }
    
    private func setUpLayout() {
        self.backgroundColor = .white
        addViews()
        setLayoutConstraints()
    }
    
    func addViews() {
        self.addSubview(logLabel)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate ([
            logLabel.topAnchor.constraint(equalTo: self.topAnchor),
            logLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            logLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            logLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setData(log: MachineLog) {
        // TODO: - Log 글자길이에 맞게 늘리기
        logLabel.text = "\(log.device.nickname) - \(log.contents) - \(log.rdate)"
    }
}

