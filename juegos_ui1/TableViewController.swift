import UIKit
import Alamofire

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var mejoresPuntajes: [EntradaHistorial] = []
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Puntajes Tócame"
        tableView.dataSource = self
        tableView.delegate = self
        
        print("🔍 TableViewController loaded with userId: \(userId ?? "nil")")
        cargarMejoresPuntajes()
    }
    
    func cargarMejoresPuntajes() {
        guard let userId = userId else {
            mejoresPuntajes = []
            mostrarAlertaError(mensaje: "No se pudo identificar al jugador.")
            return
        }
        
        guard let jwtToken = SessionManager.shared.accessToken else {
            mostrarAlertaError(mensaje: "Usuario no autenticado. Por favor, inicia sesión.")
            return
        }

        print("🔍 Loading scores for userId: \(userId)")

        HTTPClient.shared.fetchScores(jwtToken: jwtToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let scores):
                    print("🔍 Received \(scores.count) total scores")
                    
                    let puntajesJugador = scores.filter {
                        $0.userId == userId && $0.gameId == 1
                    }
                    
                    print("🔍 Found \(puntajesJugador.count) scores for user \(userId) in game 1")
                    
                    let mejores = puntajesJugador.sorted(by: { $0.score > $1.score }).prefix(10)
                    
                    self?.mejoresPuntajes = Array(mejores)
                    self?.tableView.reloadData()
                    
                    print("✅ Loaded \(mejores.count) best scores for table")
                    
                case .failure(let error):
                    print("❌ Error loading scores: \(error)")
                    self?.mostrarAlertaError(mensaje: "No se pudieron cargar los puntajes del juego.")
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
        let cellIdentifier = "TocameCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
                   UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        let puntaje = mejoresPuntajes[indexPath.row]
        let posicion = indexPath.row + 1

        cell.textLabel?.text = "\(posicion). Puntaje: \(puntaje.score) pts"
        
        cell.detailTextLabel?.text = "Fecha: \(puntaje.date)"
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let usuario = SessionManager.shared.nombreUser ?? "Usuario"
        return "Mejores puntajes de \(usuario)"
    }
}
