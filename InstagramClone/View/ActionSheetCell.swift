//
//  ActionSheetCell.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 27.03.2023.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    //MARK: - Properties
    
    var viewModel: ActionSheetViewModel? {
        didSet { configure() }
    }
    
    private let optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "trash.fill")
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test option"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(optionImageView)
        optionImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        optionImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        optionImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        optionImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: optionImageView.rightAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        optionImageView.image = viewModel.image
        
        switch viewModel.type {
        case .share:
            optionImageView.tintColor = .black
        case .delete, .report:
            optionImageView.tintColor = .red
        default:
            print("Error")
        }
    }
    
    
    
}
