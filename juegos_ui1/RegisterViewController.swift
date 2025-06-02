//
//  registerViewController.swift
//  juegos_ui1
//
//  Created by Bootcamp on 2025-05-29.
//

import UIKit

//para guardar registros
struct Usuario: Codable {
    let nombre: String
    let email: String
    let password: String
}


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
            mostrarAlerta(titulo: "Campos vacíos", mensaje: "Completa todos los campos.")
            return
        }

        guard pass == confirmPass else {
            mostrarAlerta(titulo: "Contraseñas no coinciden", mensaje: "Verifica que ambas contraseñas sean iguales.")
            return
        }

        var usuarios: [String: Usuario] = [:]
        if let data = UserDefaults.standard.data(forKey: "usuarios"),
           let cargados = try? JSONDecoder().decode([String: Usuario].self, from: data) {
            usuarios = cargados
        }

        if usuarios[nombre] != nil {
            mostrarAlerta(titulo: "Este usuario ya existe", mensaje: "Ese nombre ya está registrado.")
            return
        }

        let newUser = Usuario(nombre: nombre, email: email, password: pass)
        usuarios[nombre] = newUser

        if let encoded = try? JSONEncoder().encode(usuarios) {
            UserDefaults.standard.set(encoded, forKey: "usuarios")
        }

        alertaLogin(titulo: "Registro exitoso", mensaje: "Bienvenido \(nombre)!")
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
                self.show(loginVC, sender: nil)
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

        // Imprimir usuarios guardados para prueba
        if let data = UserDefaults.standard.data(forKey: "usuarios"),
           let cargados = try? JSONDecoder().decode([String: Usuario].self, from: data) {
            for (nombre, usuario) in cargados {
                print("Usuario: \(nombre), Email: \(usuario.email)")
            }
        }
    }
    }

