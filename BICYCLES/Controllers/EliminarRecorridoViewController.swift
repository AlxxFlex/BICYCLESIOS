//
//  EliminarRecorridoViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 31/03/25.
//

import UIKit

protocol EliminarRecorridoDelegate: AnyObject {
    func didDeleteRecorrido()
}

class EliminarRecorridoViewController: UIViewController {
    
    // MARK: - Propiedades
   var recorrido: Recorrido?
   weak var delegate: EliminarRecorridoDelegate?
   
   // MARK: - Componentes UI
   private let contenedorView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.white
       view.layer.cornerRadius = 25
       view.layer.shadowColor = UIColor.black.cgColor
       view.layer.shadowOpacity = 0.2
       view.layer.shadowOffset = CGSize(width: 0, height: 2)
       view.layer.shadowRadius = 5
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
   }()
   
   private let mensajeLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
       label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
       label.textAlignment = .center
       label.numberOfLines = 6
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
       view.backgroundColor = UIColor(red: 72/255.0, green: 159/255.0, blue: 215/255.0, alpha: 1.0)
       configurarUI()
       
       // Actualizar mensaje
       if let recorrido = recorrido {
           mensajeLabel.text = """
           ¿Estás seguro que quieres eliminar este recorrido?
           Bicicleta: \(recorrido.bicicletaNombre)
           Fecha: \(recorrido.createdAt)
           """
       }
   }
   
   // MARK: - Configuración de UI
   private func configurarUI() {
       view.addSubview(contenedorView)
       contenedorView.addSubview(mensajeLabel)
       contenedorView.addSubview(buttonStackView)
       
       NSLayoutConstraint.activate([
           contenedorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
           contenedorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
           contenedorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           contenedorView.heightAnchor.constraint(equalToConstant: 280)
       ])

       // Constraints para mensajeLabel
       NSLayoutConstraint.activate([
           mensajeLabel.topAnchor.constraint(equalTo: contenedorView.topAnchor, constant: 24),
           mensajeLabel.leadingAnchor.constraint(equalTo: contenedorView.leadingAnchor, constant: 16),
           mensajeLabel.trailingAnchor.constraint(equalTo: contenedorView.trailingAnchor, constant: -16),
           mensajeLabel.heightAnchor.constraint(equalToConstant: 150) // ✅ Más espacio para el texto
       ])

       // Constraints para buttonStackView
       NSLayoutConstraint.activate([
           buttonStackView.topAnchor.constraint(equalTo: mensajeLabel.bottomAnchor, constant: 20),
           buttonStackView.leadingAnchor.constraint(equalTo: contenedorView.leadingAnchor, constant: 16),
           buttonStackView.trailingAnchor.constraint(equalTo: contenedorView.trailingAnchor, constant: -16),
           buttonStackView.heightAnchor.constraint(equalToConstant: 50)
       ])
   }
   
   // MARK: - Acción para confirmar eliminación
    @objc func confirmarEliminar() {
        guard let id = recorrido?.id else {
            mostrarAlerta(titulo: "Error", mensaje: "No se encontró el recorrido.")
            return
        }

        // 💡 Desactivar botones mientras se elimina
        confirmarButton.isEnabled = false
        confirmarButton.alpha = 0.5
        cancelarButton.isEnabled = false
        cancelarButton.alpha = 0.5

        ApiService.shared.eliminarRecorrido(id: id) { [weak self] result in
            DispatchQueue.main.async {
                // 💡 Reactivar botones tras recibir respuesta
                self?.confirmarButton.isEnabled = true
                self?.confirmarButton.alpha = 1.0
                self?.cancelarButton.isEnabled = true
                self?.cancelarButton.alpha = 1.0

                switch result {
                case .success:
                    print("✅ Recorrido eliminado correctamente.")
                    self?.delegate?.didDeleteRecorrido()
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print("❌ Error al eliminar el recorrido: \(error.localizedDescription)")
                    self?.mostrarAlerta(titulo: "Error", mensaje: "No se pudo eliminar el recorrido.")
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
