//
//  RegisterStep1ViewController.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 16/03/25.
//

import UIKit

class RegisterStep1ViewController: UIViewController {

    @IBOutlet weak var apellidoTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    var registerData = RegisterData()
    // Creamos dos labels para errores de forma programática.
    var nameErrorLabel: UILabel!
    var apellidoErrorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupErrorLabels()
    }
    func setupErrorLabels() {
            
            nameErrorLabel = UILabel()
            nameErrorLabel.translatesAutoresizingMaskIntoConstraints = false
            nameErrorLabel.textColor = .red
            nameErrorLabel.font = UIFont.systemFont(ofSize: 12)
            nameErrorLabel.text = "El campo nombre es obligatorio."
            nameErrorLabel.isHidden = true
            
            
            apellidoErrorLabel = UILabel()
            apellidoErrorLabel.translatesAutoresizingMaskIntoConstraints = false
            apellidoErrorLabel.textColor = .red
            apellidoErrorLabel.font = UIFont.systemFont(ofSize: 12)
            apellidoErrorLabel.text = "El campo apellido es obligatorio."
            apellidoErrorLabel.isHidden = true
            
            
            view.addSubview(nameErrorLabel)
            view.addSubview(apellidoErrorLabel)
            
            
            NSLayoutConstraint.activate([
                nameErrorLabel.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 4),
                nameErrorLabel.leadingAnchor.constraint(equalTo: nameTF.leadingAnchor),
                nameErrorLabel.trailingAnchor.constraint(equalTo: nameTF.trailingAnchor)
            ])
            
            
            NSLayoutConstraint.activate([
                apellidoErrorLabel.topAnchor.constraint(equalTo: apellidoTF.bottomAnchor, constant: 4),
                apellidoErrorLabel.leadingAnchor.constraint(equalTo: apellidoTF.leadingAnchor),
                apellidoErrorLabel.trailingAnchor.constraint(equalTo: apellidoTF.trailingAnchor)
            ])
        }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
       nameErrorLabel.isHidden = true
       apellidoErrorLabel.isHidden = true
       
       var isValid = true
       if let nombre = nameTF.text, nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
           nameErrorLabel.isHidden = false
           isValid = false
       }
       if let apellido = apellidoTF.text, apellido.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
           apellidoErrorLabel.isHidden = false
           isValid = false
       }
       if isValid {
           registerData.nombre = nameTF.text
           registerData.apellido = apellidoTF.text
           performSegue(withIdentifier: "toRegisterStep2", sender: self)
       }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toRegisterStep2" {
           if let step2VC = segue.destination as? RegisterStep2ViewController {
               step2VC.registerData = self.registerData
           }
       }
   }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
