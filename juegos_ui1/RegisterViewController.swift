//
//  registerViewController.swift
//  juegos_ui1
//
//  Created by Bootcamp on 2025-05-29.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var regNom: UITextField!
    @IBOutlet weak var regEmail: UITextField!
    @IBOutlet weak var regPass: UITextField!
    @IBOutlet weak var confPass: UITextField!
        
    var contrasenas: [ingresaPass] = []

    struct ingresaPass: Codable {
        let password: String
    }
    
    func registrar() {
        guard let nombre = regNom.text, !nombre.isEmpty,
              let email = regEmail.text, !email.isEmpty,
              let pass = regPass.text, !pass.isEmpty,
              let confirmPass = confPass.text, !confirmPass.isEmpty else {
            mostrarAlerta(titulo: "Campos vacíos", mensaje: "Por favor, completa todos los campos.")
            return
        }
        
        guard pass == confirmPass else {
            mostrarAlerta(titulo: "Contraseñas no coinciden", mensaje: "Verifica que ambas contraseñas sean iguales.")
            return
        }
        
        // historial de nombre, correo y contrasena
        let nuevaEntrada = ingresaPass(password: pass)
        contrasenas.append(nuevaEntrada)
        
        if let encoded = try? JSONEncoder().encode(contrasenas) {
            UserDefaults.standard.set(encoded, forKey: "contrasenas")
        }

        print("Nombre ingresado: \(nombre)")
        print("Correo: \(email)")
        print("Contraseña: \(pass)")
        print("Confirmación: \(confirmPass)")
        
        alertaLogin(titulo: "Registro exitoso", mensaje: "Bienvenido \(nombre)!")
        
        print(contrasenas)
    }

        
        
        
    
    func mostrarAlerta(titulo: String, mensaje: String) {
         let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
         alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alerta, animated: true, completion: nil)
     }

     func alertaLogin(titulo: String, mensaje: String) {
         let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ir a Inicio", style: .default) { _ in
             if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
                 loginVC.modalPresentationStyle = .fullScreen
                 self.present(loginVC, animated: true, completion: nil)
             }
         }
         alerta.addAction(okAction)
         present(alerta, animated: true, completion: nil)
     }
    
    @IBAction func btnRegistrar(_ sender: Any) {
        registrar()
    }
    
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            regNom.clearButtonMode = .whileEditing
            regEmail.clearButtonMode = .whileEditing
            regPass.clearButtonMode = .whileEditing
            confPass.clearButtonMode = .whileEditing
            if let data = UserDefaults.standard.data(forKey: "contrasenas"),
               let allPasswords = try? JSONDecoder().decode([ingresaPass].self, from: data) {
                self.contrasenas = allPasswords
            }

        }
    }

