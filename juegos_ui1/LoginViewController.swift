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
        super.viewDidLoad()
        user1.clearButtonMode = .whileEditing
        passLogin.clearButtonMode = .whileEditing
        self.navigationController?.navigationBar.tintColor = .purple
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        guard let email = user1.text, !email.isEmpty,
              let password = passLogin.text, !password.isEmpty else {
            showAlert(message: "Completa todos los campos.")
            return
        }
        loginSupabase(email: email, password: password)
    }

    @IBAction func btnSignUp(_ sender: Any) {
        if let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") {
            self.show(registerVC, sender: nil)
        }
    }
    
    @IBAction func btnTopTen(_ sender: Any) {
        verTopTen()
    }
    
    func loginSupabase(email: String, password: String) {
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE"
        let url = URL(string: "https://lvmybcyhrbisfjouhbrx.supabase.co/auth/v1/token?grant_type=password")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        let body: [String: String] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(message: "Error de red: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self.showAlert(message: "No se recibió respuesta del servidor.")
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let token = json["access_token"] as? String {
                        self.obtenerPerfil(token: token)
                    } else if let errorMsg = json["error_description"] as? String {
                        self.showAlert(message: errorMsg)
                    } else {
                        self.showAlert(message: "Error desconocido. Intenta más tarde.")
                    }
                }
            }
        }.resume()
    }

    func obtenerPerfil(token: String) {
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE"
        let url = URL(string: "https://lvmybcyhrbisfjouhbrx.supabase.co/auth/v1/user")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(message: "Error al obtener perfil: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self.showAlert(message: "No se recibió respuesta del perfil.")
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let meta = json["user_metadata"] as? [String: Any],
                   let username = meta["username"] as? String {
                    self.showAlertSuccess(message: "¡Inicio de sesión exitoso!", nombre: username)
                } else {
                    self.showAlert(message: "No se pudo obtener el username.")
                }
            }
        }.resume()
    }
    
    func verTopTen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let topTenVC = storyboard.instantiateViewController(withIdentifier: "TopTenVC") as? TopTenViewController {
            self.present(topTenVC, animated: true)
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showAlertSuccess(message: String, nombre: String) {
        let alert = UIAlertController(title: "Inicio exitoso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.irAHomeConNombre(nombre: nombre)
        })
        present(alert, animated: true)
    }
    
    func irAHomeConNombre(nombre: String) {
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController") as! HomeViewController
        homeVC.nomUser = nombre
        self.show(homeVC, sender: nil)
    }
}
