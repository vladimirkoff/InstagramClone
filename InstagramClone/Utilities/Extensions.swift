//
//  Extensions.swift
//  InstagramClone
//
//  Created by Vladimir Kovalev on 22.03.2023.
//

import UIKit

extension UIButton {
    func attributedTitle(first: String, second: String) {
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.7), .font: UIFont.systemFont(ofSize: 14)]
        let attributedTitle = NSMutableAttributedString(string: "\(first) ", attributes: atts)
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.7), .font: UIFont.boldSystemFont(ofSize: 14)]
        attributedTitle.append(NSAttributedString(string: second, attributes: boldAtts))
        setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension UIViewController {
    func configureGradient() {
        let gradient = CAGradientLayer() // - combination of two+ colors
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0,1] // starts from top and ends at bottom
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
}
