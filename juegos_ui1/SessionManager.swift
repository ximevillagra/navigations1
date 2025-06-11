import Foundation
import Alamofire

class SessionManager {
  static let shared = SessionManager()
  private init() {}

  var accessToken: String? {
    get { UserDefaults.standard.string(forKey: "accessToken") }
    set { UserDefaults.standard.set(newValue, forKey: "accessToken") }
  }

  var userId: String? {
    get { UserDefaults.standard.string(forKey: "userId") }
    set { UserDefaults.standard.set(newValue, forKey: "userId") }
  }

  var nombreUser: String? {
    get { UserDefaults.standard.string(forKey: "nombreUser") }
    set { UserDefaults.standard.set(newValue, forKey: "nombreUser") }
  }

  func guardarSesion(token: String, userId: String, nombreUser: String) {
    self.accessToken = token
    self.userId = userId
    self.nombreUser = nombreUser
  }

  func cerrarSesion() {
    UserDefaults.standard.removeObject(forKey: "accessToken")
    UserDefaults.standard.removeObject(forKey: "userId")
    UserDefaults.standard.removeObject(forKey: "nombreUser")
  }
}
