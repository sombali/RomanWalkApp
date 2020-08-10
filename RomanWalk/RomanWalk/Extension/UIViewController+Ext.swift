//
//  UIViewController+Ext.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 25..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

extension UIViewController {
    
    func hideMessage() {
        SwiftMessages.hide()
    }

    //MARK: One button
    func showMessageWithOneButton(title: String?, body: String?, iconImage: UIImage?, iconText: String?, buttonImage: UIImage?, buttonTitle: String?, with closure: ((UIButton) -> Void)?, interactive: Bool? = nil, interactiveHide: Bool? = nil) {
        let view: MessageView = MessageView.viewFromNib(layout: .centeredView)
        view.configureBackgroundView(width: 300)
        view.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        view.backgroundView.layer.cornerRadius = 10
        view.configureContent(title: title, body: body, iconImage: iconImage, iconText: iconText, buttonImage: buttonImage, buttonTitle: buttonTitle, buttonTapHandler: closure)
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        if let interactive = interactive {
            config.dimMode = .blur(style: .dark, alpha: 0.8, interactive: interactive)
        } else {
            config.dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
        }
        
        if let interactiveHide = interactiveHide {
            config.interactiveHide = interactiveHide
        }
        
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: view)
    }
    
    //MARK: Navigation view
    func showTwoButtonWithTitleMessageView(title: String?, firstButtonTitle: String?, secondButtonTitle: String?, firstButtonHandler: (() -> Void)?, secondButtonHandler: (() -> Void)?) {
        let view: TitleWithTwoButtonMessageView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        view.configureBackgroundView(width: 250)
        
        view.twoButtonTitleLabel.text = title
        view.firstButton.setTitle(firstButtonTitle, for: .normal)
        view.secondButton.setTitle(secondButtonTitle, for: .normal)
        view.firstButtonHandler = firstButtonHandler
        view.secondButtonHandler = secondButtonHandler
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .blur(style: .dark, alpha: 0.7, interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
    //MARK: QR code menu
    func showQRCodeMenu(redeem: (() -> Void)?, inspect: (() -> Void)?) {
        let view: CoinOptionsView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        view.configureBackgroundView(width: 250)
        view.redeem = redeem
        view.inspect = inspect
        
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .blur(style: .dark, alpha: 0.7, interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
    //MARK: SimpleMessage
    func showSimpleMessage(title: String?, body: String?, iconImage: UIImage?, iconText: String?, buttonImage: UIImage?, buttonTitle: String?, with closure: ((UIButton) -> Void)?, theme: Theme? = nil, interactive: Bool? = nil, interactiveHide: Bool? = nil) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureDropShadow()
        view.button?.isHidden = true
        
        if let theme = theme {
            view.configureTheme(theme)
        }
        
        if theme == .warning {
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            view.configureContent(title: title, body: body, iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        } else {
            if let title = title, let body = body {
                view.configureContent(title: title, body: body)
            }
        }
        
        var viewConfig = SwiftMessages.defaultConfig
        viewConfig.presentationStyle = .center
        viewConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        
        SwiftMessages.show(config: viewConfig, view: view)
    }
    
    //MARK: network popup
    func showNetworkNotReachableStatusBar() {
        let status = MessageView.viewFromNib(layout: .statusLine)
        status.backgroundView.backgroundColor = UIColor.red
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: "A hálózat nem elérhető")
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        statusConfig.preferredStatusBarStyle = .lightContent
        statusConfig.duration = .forever
        SwiftMessages.show(config: statusConfig, view: status)
    }
}
