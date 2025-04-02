//
//  EliminarBicicletaViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 31/03/25.
//

import UIKit

protocol EliminarBicicletaDelegate: AnyObject {
    func didDeleteBicicleta()
}

class EliminarBicicletaViewController: UIViewController {
    
    // MARK: - Propiedades
    var bicicleta: Bicicleta?
    weak var delegate: EliminarBicicletaDelegate?
    
    // MARK: - Componentes UI
    private let contenedorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 25 // 🎨 Más redondeado para hacerlo más bonito
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mensajeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black // 🎨 Texto negro para mejor contraste
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold) // ✅ Texto en negrita
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirmar", for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 18)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(confirmarEliminar), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancelar", for: .normal)
        button.backgroundColor = UIColor.systemGray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 18)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(cancelarEliminar), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelarButton, confirmarButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar vista
        view.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 225/255.0, alpha: 1.0)
        configurarUI()
        
        // Actualizar mensaje
        if let bicicleta = bicicleta {
            mensajeLabel.text = "¿Estás seguro que quieres eliminar la bicicleta \"\(bicicleta.nombre)\"?"
        }
    }
    
    // MARK: - Configuración de UI
    private func configurarUI() {
        view.addSubview(contenedorView)
        contenedorView.addSubview(mensajeLabel)
        contenedorView.addSubview(buttonStackView)
        
        // Constraints para contenedor (más grande)
        NSLayoutConstraint.activate([
            contenedorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contenedorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contenedorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contenedorView.heightAnchor.constraint(equalToConstant: 230) // 📏 Altura más grande
        ])
        
        // Constraints para mensajeLabel
        NSLayoutConstraint.activate([
            mensajeLabel.topAnchor.constraint(equalTo: contenedorView.topAnchor, constant: 24),
            mensajeLabel.leadingAnchor.constraint(equalTo: contenedorView.leadingAnchor, constant: 20),
            mensajeLabel.trailingAnchor.constraint(equalTo: contenedorView.trailingAnchor, constant: -20),
            mensajeLabel.heightAnchor.constraint(equalToConstant: 80) // 📏 Más espacio para el texto
        ])
        
        // Constraints para buttonStackView
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: mensajeLabel.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: contenedorView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contenedorView.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Acción para confirmar eliminación
    @objc func confirmarEliminar() {
        guard let id = bicicleta?.id else {
            mostrarAlerta(titulo: "Error", mensaje: "No se encontró la bicicleta.")
            return
        }
        
        // 💡 Desactivar botón mientras se elimina
        confirmarButton.isEnabled = false
        confirmarButton.alpha = 0.5
        cancelarButton.isEnabled = false
        cancelarButton.alpha = 0.5

        ApiService.shared.eliminarBicicleta(id: id) { [weak self] result in
            DispatchQueue.main.async {
                // 💡 Reactivar botones tras respuesta
                self?.confirmarButton.isEnabled = true
                self?.confirmarButton.alpha = 1.0
                self?.cancelarButton.isEnabled = true
                self?.cancelarButton.alpha = 1.0

                switch result {
                case .success:
                    self?.delegate?.didDeleteBicicleta()
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print("❌ Error al eliminar la bicicleta: \(error.localizedDescription)")
                    self?.mostrarAlerta(titulo: "Error", mensaje: "No se pudo eliminar la bicicleta.")
                }
            }
        }
    }
    
    // MARK: - Acción para cancelar eliminación
    @objc func cancelarEliminar() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Mostrar alerta en caso de error
    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
}
