//
//  RecorridoCell.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 29/03/25.
//

import UIKit

class RecorridoCell: UITableViewCell {
    
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
    
    let recorridoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imagenrecorrido") // Asegúrate de que esta imagen esté en tus assets
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nombreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 16) // Fuente más pequeña
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanciaLabel: UILabel = createLabel()
    let tiempoLabel: UILabel = createLabel()
    let caloriasLabel: UILabel = createLabel()
    let fechaLabel: UILabel = createLabel(size: 12, color: .gray)
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let deleteImage = UIImage(systemName: "trash.circle.fill")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25)) // Tamaño ajustado
        button.setImage(deleteImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let viewButton: UIButton = {
        let button = UIButton(type: .system)
        let viewImage = UIImage(systemName: "eye.fill")?
            .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(viewImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Inicialización de la celda
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default // Asegúrate de que la celda se pueda seleccionar
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Crear Label
    private static func createLabel(size: CGFloat = 14, color: UIColor = .darkGray) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: - Configurar Vistas
    private func setupViews() {
        contentView.backgroundColor = UIColor(red: 0.80, green: 0.90, blue: 1.0, alpha: 1.0)
        contentView.addSubview(containerView)
        
        containerView.addSubview(recorridoImageView)
        containerView.addSubview(nombreLabel)
        containerView.addSubview(distanciaLabel)
        containerView.addSubview(tiempoLabel)
        containerView.addSubview(caloriasLabel)
        containerView.addSubview(fechaLabel)
        containerView.addSubview(deleteButton)
        containerView.addSubview(viewButton)
        
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
            
            // Imagen cuadrada a la izquierda
            recorridoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            recorridoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            recorridoImageView.widthAnchor.constraint(equalToConstant: 70), // Imagen cuadrada
            recorridoImageView.heightAnchor.constraint(equalToConstant: 70),
            
 
            
          // Restricción para el botón de eliminar (arriba a la derecha)
          deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
          deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
          deleteButton.widthAnchor.constraint(equalToConstant: 35),
          deleteButton.heightAnchor.constraint(equalToConstant: 35),
          
          // Restricción para el botón de ver (ojito) en la esquina inferior derecha
          viewButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
          viewButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
          viewButton.widthAnchor.constraint(equalToConstant: 35),
          viewButton.heightAnchor.constraint(equalToConstant: 25),
            
            // Nombre de la bicicleta a la derecha de la imagen
            nombreLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            nombreLabel.leadingAnchor.constraint(equalTo: recorridoImageView.trailingAnchor, constant: 10),
            nombreLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10),
            
            // Distancia
            distanciaLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 5),
            distanciaLabel.leadingAnchor.constraint(equalTo: recorridoImageView.trailingAnchor, constant: 10),
            distanciaLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            // Tiempo
            tiempoLabel.topAnchor.constraint(equalTo: distanciaLabel.bottomAnchor, constant: 5),
            tiempoLabel.leadingAnchor.constraint(equalTo: recorridoImageView.trailingAnchor, constant: 10),
            tiempoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            // Calorías
            caloriasLabel.topAnchor.constraint(equalTo: tiempoLabel.bottomAnchor, constant: 5),
            caloriasLabel.leadingAnchor.constraint(equalTo: recorridoImageView.trailingAnchor, constant: 10),
            caloriasLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            // Fecha
            fechaLabel.topAnchor.constraint(equalTo: caloriasLabel.bottomAnchor, constant: 5),
            fechaLabel.leadingAnchor.constraint(equalTo: recorridoImageView.trailingAnchor, constant: 10),
            fechaLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            fechaLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Configurar Celda
    func configure(with recorrido: Recorrido, target: Any, deleteAction: Selector, viewAction: Selector, index: Int) {
        nombreLabel.text = recorrido.bicicletaNombre
        distanciaLabel.text = "Distancia: \(recorrido.distanciaRecorrida) m"
        tiempoLabel.text = "Tiempo: \(recorrido.tiempo) s"
        caloriasLabel.text = "Calorías: \(recorrido.calorias)"
        fechaLabel.text = "Fecha: \(recorrido.createdAt)"
        
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
        viewButton.removeTarget(nil, action: nil, for: .allEvents)
        
        deleteButton.tag = index
        deleteButton.addTarget(target, action: deleteAction, for: .touchUpInside)
        
        viewButton.tag = index
        viewButton.addTarget(target, action: viewAction, for: .touchUpInside)
    }
}
