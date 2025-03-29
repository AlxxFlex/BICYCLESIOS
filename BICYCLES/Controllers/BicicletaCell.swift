//
//  BicicletaCell.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 29/03/25.
//

import UIKit

class BicicletaCell: UITableViewCell {
    
    // MARK: - Elementos UI
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bicicletaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Imgparabici")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nombreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        let editImage = UIImage(systemName: "pencil.circle.fill")?
            .withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(editImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let deleteImage = UIImage(systemName: "trash.circle.fill")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(deleteImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Inicialización de la celda
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurar Vistas
    private func setupViews() {
        contentView.backgroundColor = UIColor(red: 0.80, green: 0.90, blue: 1.0, alpha: 1.0)
        contentView.addSubview(containerView)
        
        containerView.addSubview(bicicletaImageView)
        containerView.addSubview(nombreLabel)
        containerView.addSubview(editButton)
        containerView.addSubview(deleteButton)
        
        setupConstraints()
    }
    
    // MARK: - Configurar Restricciones
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container View
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Imagen de la bicicleta
            bicicletaImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            bicicletaImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bicicletaImageView.widthAnchor.constraint(equalToConstant: 120),
            bicicletaImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Nombre de la bicicleta (centrado)
            nombreLabel.leadingAnchor.constraint(equalTo: bicicletaImageView.trailingAnchor, constant: 10),
            nombreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -60),
            nombreLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // Botón para editar (esquina superior derecha)
            editButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            editButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Botón para eliminar (esquina inferior derecha)
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Configurar Celda
    func configure(with bicicleta: Bicicleta, target: Any, editAction: Selector, deleteAction: Selector, index: Int) {
        nombreLabel.text = bicicleta.nombre
        
        editButton.tag = index
        deleteButton.tag = index
        
        editButton.addTarget(target, action: editAction, for: .touchUpInside)
        deleteButton.addTarget(target, action: deleteAction, for: .touchUpInside)
    }
}
