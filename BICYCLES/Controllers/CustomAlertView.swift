//
//  CustomAlertView.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 02/04/25.
//

import UIKit

class CustomAlertView: UIView {
    
    static func showSuccessAlert(message: String, completion: (() -> Void)? = nil) {
        showAlert(message: message, iconName: "checkmark.circle.fill", iconColor: .systemGreen, completion: completion)
    }

    static func showErrorAlert(message: String, completion: (() -> Void)? = nil) {
        showAlert(message: message, iconName: "xmark.octagon.fill", iconColor: .systemRed, completion: completion)
    }
    static func showYellowAlert(message: String, completion: (() -> Void)? = nil) {
        showAlert(message: message,iconName: "exclamationmark.triangle.fill", iconColor: .systemYellow, completion: completion)
    }

    private static func showAlert(message: String, iconName: String, iconColor: UIColor, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.windows.first else { return }

        let background = UIView(frame: window.bounds)
        background.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        let alertBox = UIView()
        alertBox.translatesAutoresizingMaskIntoConstraints = false
        alertBox.backgroundColor = .white
        alertBox.layer.cornerRadius = 15
        alertBox.clipsToBounds = true

        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = iconColor
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit

        let label = UILabel()
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        alertBox.addSubview(icon)
        alertBox.addSubview(label)
        background.addSubview(alertBox)
        window.addSubview(background)

        NSLayoutConstraint.activate([
            alertBox.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            alertBox.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            alertBox.widthAnchor.constraint(equalToConstant: 260),
            alertBox.heightAnchor.constraint(equalToConstant: 180),

            icon.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 20),
            icon.centerXAnchor.constraint(equalTo: alertBox.centerXAnchor),
            icon.widthAnchor.constraint(equalToConstant: 50),
            icon.heightAnchor.constraint(equalToConstant: 50),

            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: -20)
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            background.removeFromSuperview()
            completion?()
        }
    }
}
