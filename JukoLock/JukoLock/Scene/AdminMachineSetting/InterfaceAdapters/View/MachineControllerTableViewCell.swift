//
//  MachineControllerTableViewCell.swift
//  JukoLock
//
//  Created by 김경호 on 10/26/24.
//

import UIKit

final class MachineControllerTableViewCell: UITableViewCell {
    public static let identifier: String = "MachineControllerTableViewCell"
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = .preferredFont(forTextStyle: .caption1)
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    private func setView() {
        self.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func setCell(_ text:String) {
        textView.text = text
    }
}
