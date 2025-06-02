//
//  LoginViewController.swift
//  juegos_ui1
//
//  Created by Bootcamp on 2025-05-30.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var user1: UITextField!
    @IBOutlet weak var passLogin: UITextField!
    
    override func viewDidLoad() {
        user1.clearButtonMode = .whileEditing
        passLogin.clearButtonMode = .whileEditing
        super.viewDidLoad()
    }
    
    
    func home(usuario: Usuario) {
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController") as! HomeViewController
        firstVC.nomUser = usuario.nombre
        self.show(firstVC, sender: nil)
    }
    
    
    func registro() {
        guard storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") is RegisterViewController else {
            return
        }
    }

    
    @IBAction func btnLogin(_ sender: UIButton) {
        guard let intentoInicio = user1.text, !intentoInicio.isEmpty,
              let password = passLogin.text, !password.isEmpty else {
            showAlert(message: "Completa todos los campos.")
            return
        }
        guard let data = UserDefaults.standard.data(forKey: "usuarios"),
              let usuarios = try? JSONDecoder().decode([String: Usuario].self, from: data) else {
            showAlert(message: "No hay usuarios registrados.")
            return
        }
        let foundUser = usuarios.values.first {
            ($0.nombre == intentoInicio || $0.email == intentoInicio) && $0.password == password
        }

        if let usuario = foundUser {
            home(usuario: usuario)
            showAlert2(message: "Hola, \(usuario.nombre)!")
        } else {
            showAlert(message: "Usuario/email o contraseña incorrectos.")
        }
        
        
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showAlert2(message: String) {
        let alert = UIAlertController(title: "Inicio exitoso!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        registro()
    }
    
    func verTopTen() {
        //func para tabla con el top 10 generallll
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let TopTenVC = storyboard.instantiateViewController(withIdentifier: "TopTenVC") as? TopTenViewController {
            self.present(TopTenVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnTopTen(_ sender: Any) {
        verTopTen()
    }
    
    
}

