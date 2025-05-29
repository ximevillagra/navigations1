import Foundation

class Jugador1y2 {
    var mano: [(Int, String)] = []

    init(baraja: inout [(Int, String)]) {
        for _ in 1...5 {
            if let carta = baraja.randomElement(),
               let index = baraja.firstIndex(where: { $0 == carta }) {
                mano.append(carta)
                baraja.remove(at: index)
            }
        }
    }
}

class Juego {
    let mano: [(Int, String)]

    init(mano: [(Int, String)]) {
        self.mano = mano
    }

    func verificar() -> String {
        if esEscaleraColor() { return "Escalera de Color" }
        if esPoker() { return "Poker" }
        if esFull() { return "Full" }
        if esColor() { return "Color" }
        if esEscalera() { return "Escalera" }
        if esTrio() { return "Trío" }
        if esDoblePar() { return "Doble Par" }
        if esPar() { return "Par" }
        return "Carta Alta"
    }

    func puntaje() -> Int {
        if esEscaleraColor() { return 9 }
        if esPoker()         { return 8 }
        if esFull()          { return 7 }
        if esColor()         { return 6 }
        if esEscalera()      { return 5 }
        if esTrio()          { return 4 }
        if esDoblePar()      { return 3 }
        if esPar()           { return 2 }
        return 1
    }

    private func valores() -> [Int] {
        return mano.map { $0.0 }.sorted()
    }

    private func palo() -> [String] {
        return mano.map { $0.1 }
    }

    private func contValor() -> [Int: Int] {
        var conteo: [Int: Int] = [:]
        for carta in mano {
            conteo[carta.0, default: 0] += 1
        }
        return conteo
    }

    private func esColor() -> Bool {
        return Set(palo()).count == 1
    }

    private func esEscalera() -> Bool {
        let vals = Set(valores()).sorted()

        // Caso especial: A, 10, J, Q, K
        if vals == [1, 10, 11, 12, 13] {
            return true
        }

        // Evita duplicados y chequea que todos sean consecutivos
        if vals.count != 5 { return false }

        for i in 0..<vals.count - 1 {
            if vals[i + 1] - vals[i] != 1 {
                return false
            }
        }

        return true
    }


    private func esEscaleraColor() -> Bool {
        return esEscalera() && esColor()
    }

    private func esPoker() -> Bool {
        return contValor().contains { $0.value == 4 }
    }

    private func esFull() -> Bool {
        let valores = contValor().values.sorted()
        return valores == [2, 3]
    }

    private func esTrio() -> Bool {
        return contValor().contains { $0.value == 3 }
    }

    private func esDoblePar() -> Bool {
        return contValor().filter { $0.value == 2 }.count == 2
    }

    private func esPar() -> Bool {
        return contValor().filter { $0.value == 2 }.count == 1
    }
}

class casino {
    var baraja: [(Int, String)] = []
    var jugador1: Jugador1y2?
    var jugador2: Jugador1y2?

    init() {
        for num in 1...13 {
            baraja += [(num, "S"), (num, "H"), (num, "C"), (num, "D")]
        }
    }

    func repartirCartas() {
        jugador1 = Jugador1y2(baraja: &baraja)
        jugador2 = Jugador1y2(baraja: &baraja)
    }

    func enfrentar() {
        
//        // Prueba manual
//        jugador1?.mano = [(3, "H"), (3, "D"), (3, "S"), (3, "C"), (9, "H")] // Poker
//        jugador2?.mano = [(2, "S"), (3, "S"), (4, "S"), (5, "S"), (6, "S")] // Escalera de Color

        guard let jugador1 = jugador1, let jugador2 = jugador2 else {
            print("Faltan jugadores")
            return
        }
        

        let juego1 = Juego(mano: jugador1.mano)
        let juego2 = Juego(mano: jugador2.mano)

        let puntaje1 = juego1.puntaje()
        let puntaje2 = juego2.puntaje()

        print("\nJugador 1: \(jugador1.mano) - Juego: \(juego1.verificar())")
        print("\nJugador 2: \(jugador2.mano) - Juego: \(juego2.verificar())")

        if puntaje1 > puntaje2 {
            print("\nGana jugador 1")
        } else if puntaje2 > puntaje1 {
            print("\nGana jugador 2")
        } else {
            let valores1 = juego1.mano.map { $0.0 }.sorted(by: >)
            let valores2 = juego2.mano.map { $0.0 }.sorted(by: >)

            for (v1, v2) in zip(valores1, valores2) {
                if v1 > v2 {
                    print("\nAmbos tienen el mismo juego. Gana JUGADOR 1 por diferencia de valores")
                    return
                } else if v2 > v1 {
                    print("\nAmbos tienen el mismo juego. Gana JUGADOR 2 por diferencia de valores")
                    return
                }
            }

            print("\nEmpate")
        }
    }
}
