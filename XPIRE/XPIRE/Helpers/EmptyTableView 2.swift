//
//  EmptyTableView.swift
//  XPIRE
//
//  Created by Nurzhan Kanatzhanov on 4/2/21.
//

import Foundation
import UIKit

// a helper extension for UITableViews when the results are empty - creating a nice message for the user to enhance the UX. Idea taken from this medium article: https://medium.com/@mtssonmez/handle-empty-tableview-in-swift-4-ios-11-23635d108409
public extension UITableView {
    // empty view including an animated image
    func setEmptyView(title: String, message: String, titleColor: UIColor, msgColor: UIColor, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = titleColor
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = msgColor
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(messageImageView)
        
        titleLabel.text = title
        messageLabel.text = message
        messageImageView.image = messageImage
        
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20),
            messageImageView.widthAnchor.constraint(equalToConstant: 64),
            messageImageView.heightAnchor.constraint(equalToConstant: 64),
            
            titleLabel.topAnchor.constraint(equalTo: emptyView.layoutMarginsGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: emptyView.layoutMarginsGuide.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: emptyView.layoutMarginsGuide.leadingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20),
            messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20)
        ])
        
        // animating the scaling up and back for the image
        UIView.animate(withDuration: 2.5, animations: {
            messageImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)//CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 2.5, animations: {
                messageImageView.transform = CGAffineTransform(scaleX: 1, y: 1)//CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finish) in
                UIView.animate(withDuration: 2.5, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
                    
        })
        
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    // empty view without an animated image
    func setEmptyView(title: String, message: String, titleColor: UIColor, msgColor: UIColor) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = titleColor
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = msgColor
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        titleLabel.text = title
        messageLabel.text = message
        
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: emptyView.layoutMarginsGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: emptyView.layoutMarginsGuide.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: emptyView.layoutMarginsGuide.leadingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20),
            messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20)
        ])
        
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    // restore the background view of the tableview and set the separator style back to normal
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
