//
//  UserTopViewController.swift
//  juegos_ui1
//
//  Created by Bootcamp on 2025-06-02.
//

import UIKit

class UserTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var mejoresPuntajes: [EntradaHistorial] = []

    struct EntradaHistorial: Codable {
        let nombre: String
        let puntaje: Int
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        cargarMejoresPuntajes()
    }

    func cargarMejoresPuntajes() {
        guard let usuarioActual = UserDefaults.standard.string(forKey: "usuarioActual") else { return }

        if let data = UserDefaults.standard.data(forKey: "historial"),
           let historial = try? JSONDecoder().decode([EntradaHistorial].self, from: data) {
            
            let puntajesUsuario = historial.filter { $0.nombre == usuarioActual }
            mejoresPuntajes = puntajesUsuario.sorted(by: { $0.puntaje > $1.puntaje })
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mejoresPuntajes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "celdaConDetalle"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        let jugador = mejoresPuntajes[indexPath.row]
        cell?.textLabel?.text = jugador.nombre
        cell?.detailTextLabel?.text = "\(jugador.puntaje) pts"
        return cell!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let usuario = UserDefaults.standard.string(forKey: "usuarioActual") ?? "Usuario"
        return "Puntos obtenidos por \(usuario):"
    }
}
