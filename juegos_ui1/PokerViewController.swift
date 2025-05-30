import UIKit

class PokerViewController: UIViewController {
    var mesa = casino()

    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    
    @IBOutlet weak var carta1: UIImageView!
    @IBOutlet weak var carta2: UIImageView!
    @IBOutlet weak var carta3: UIImageView!
    @IBOutlet weak var carta4: UIImageView!
    @IBOutlet weak var carta5: UIImageView!
    @IBOutlet weak var carta6: UIImageView!
    @IBOutlet weak var carta7: UIImageView!
    @IBOutlet weak var carta8: UIImageView!
    @IBOutlet weak var carta9: UIImageView!
    @IBOutlet weak var carta10: UIImageView!
    
    
    @IBOutlet weak var eti1: UILabel!
    @IBOutlet weak var eti2: UILabel!
    
    var nombre1: String?
    var nombre2: String?
    var juegoSeleccionado: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mostrar los nombres en las etiquetas
        eti1.text = nombre1
        eti2.text = nombre2

            // Opcional: mostrar en consola
        print("Juego elegido: \(juegoSeleccionado ?? "Ninguno")")

        eti1.isHidden = true
        eti2.isHidden = true
        
    }
    
    func nombreImagen(valor: Int, palo: String) -> String {
        let valorStr: String
        switch valor {
        case 11: valorStr = "J"
        case 12: valorStr = "Q"
        case 13: valorStr = "K"
        case 1: valorStr = "A"
        case 10: valorStr = "T"
        default: valorStr = "\(valor)"
        }
        return "\(valorStr)\(palo)"
    }
    
    func boton() {
            mesa = casino()
            mesa.repartirCartas()
            mesa.enfrentar()
            
            eti1.isHidden = false
            eti2.isHidden = false
            
            let cartasJugador1 = mesa.jugador1?.mano ?? []
            let cartasJugador2 = mesa.jugador2?.mano ?? []
            
            let imagenesJugador1 = [carta1, carta2, carta3, carta4, carta5]
            let imagenesJugador2 = [carta6, carta7, carta8, carta9, carta10]
            
            for (index, carta) in cartasJugador1.enumerated() {
                let nombre = nombreImagen(valor: carta.0, palo: carta.1)
                imagenesJugador1[index]?.image = UIImage(named: "\(nombre).png")
            }
            
            
            for (index, carta) in cartasJugador2.enumerated() {
                let nombre = nombreImagen(valor: carta.0, palo: carta.1)
                imagenesJugador2[index]?.image = UIImage(named: "\(nombre).png")
            }
            
            
//            eti1.text = nombre1
            eti2.text = nombre2
            func mostrarGanador(titulo: String, mensaje: String) {
                let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alerta, animated: true, completion: nil)
            }
            let juego1 = Juego(mano: cartasJugador1)
            let juego2 = Juego(mano: cartasJugador2)
            
//            let nombre1 = nombre1 ?? "Jugador 1"
            let nombre2 = nombre2 ?? "Jugador 2"
            
            let jugada1 = juego1.verificar()
            let jugada2 = juego2.verificar()
            
            let puntaje1 = juego1.puntaje()
            let puntaje2 = juego2.puntaje()
            
            if puntaje1 > puntaje2 {
                mostrarGanador(titulo: "¡Ganador!", mensaje: " ganó con \(jugada1)!")
                stack1.backgroundColor = UIColor.systemGreen
                stack2.backgroundColor = UIColor.systemRed
            } else if puntaje2 > puntaje1 {
                mostrarGanador(titulo: "¡Ganador!", mensaje: "\(nombre2) ganó con \(jugada2)!")
                stack1.backgroundColor = UIColor.systemRed
                stack2.backgroundColor = UIColor.systemGreen
            } else {
                mostrarGanador(titulo: "Empate", mensaje: "Ambos jugadores tienen \(jugada1)")
                stack1.backgroundColor = UIColor.systemTeal
                stack2.backgroundColor = UIColor.systemTeal
            }
    }
    
    func tocame(){
        let thirdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController") as! TocameViewController
            
//            thirdVC.nombre = eti1.text
            
            self.show(thirdVC, sender: nil)
    }
    @IBAction func btnJugar(_ sender: Any) {
        boton()
    }
    
    @IBAction func btnTocame(_ sender: Any) {
        
        tocame()
    }
}



