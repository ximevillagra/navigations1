import Foundation
import UIKit
import Alamofire

class UserTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var mejoresPuntajes: [EntradaHistorial] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mis Puntajes"
        tableView.delegate = self
        tableView.dataSource = self
        
        cargarMejoresPuntajes()
    }
    
    @objc func cerrarModal() {
        dismiss(animated: true)
    }

    func cargarMejoresPuntajes() {
        guard let usuarioIdActual = SessionManager.shared.userId else {
            print("Usuario no logueado")
            mostrarAlertaError(mensaje: "No se pudo identificar al usuario. Inicia sesión nuevamente.")
            return
        }
        guard let jwtToken = SessionManager.shared.accessToken else {
            print("Token JWT no disponible")
            mostrarAlertaError(mensaje: "Debes iniciar sesión para ver tus puntajes.")
            return
        }

        HTTPClient.shared.fetchScores(jwtToken: jwtToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let scores):
                    let puntajesUsuario = scores.filter { $0.userId == usuarioIdActual }
                    self?.mejoresPuntajes = puntajesUsuario.sorted(by: { $0.score > $1.score })
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error al cargar puntajes: \(error)")
                    self?.mostrarAlertaError(mensaje: "No se pudieron cargar los puntajes. Verifica tu conexión.")
                }
            }
        }
    }




    func mostrarAlertaError(mensaje: String) {
        let alert = UIAlertController(
            title: "Error",
            message: mensaje,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mejoresPuntajes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UserTopCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
                   UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        
        let puntaje = mejoresPuntajes[indexPath.row]
        let posicion = indexPath.row + 1

        let juegoTexto: String
        let gameId = puntaje.gameId
        switch gameId {
        case 0:
            juegoTexto = "Poker"
        case 1:
            juegoTexto = "Tócame"
        default:
            juegoTexto = "Juego \(gameId)"
        }
        
        cell.textLabel?.text = "\(posicion)"
        cell.detailTextLabel?.text = "\(puntaje.score) pts"
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let usuario = SessionManager.shared.nombreUser ?? "Usuario"
        return "Puntajes de \(usuario)"
    }
}
