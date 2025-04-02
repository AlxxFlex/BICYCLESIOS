//
//  SelectBicycleCell.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 02/04/25.
//

import UIKit

class SelectBicycleCell: UITableViewCell {

    static let identifier = "SelectBicycleCell"
        
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bicicletaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Imgparabici")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nombreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 22)
        label.textColor = .darkGray
        label.numberOfLines = 3
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(containerView)
        containerView.addSubview(bicicletaImageView)
        containerView.addSubview(nombreLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            bicicletaImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            bicicletaImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bicicletaImageView.widthAnchor.constraint(equalToConstant: 100),
            bicicletaImageView.heightAnchor.constraint(equalToConstant: 100),

            nombreLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nombreLabel.leadingAnchor.constraint(equalTo: bicicletaImageView.trailingAnchor, constant: 16),
            nombreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            nombreLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20)
        ])
    }

    func configurarCon(bicicleta: Bicicleta) {
        nombreLabel.text = bicicleta.nombre
    }
}
