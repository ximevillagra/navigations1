import Foundation
import Alamofire

enum HTTPClientError: Error {
    case requestFailed
    case decodingFailed
    case encodingFailed
    case invalidURL
    case invalidRequestBody
    case networkError(String)
    case invalidResponse
    case serverError(statusCode: Int)
}

class HTTPClient {
    static let shared = HTTPClient()
    private init() {}
    
    private let baseURL = "https://lvmybcyhrbisfjouhbrx.supabase.co/rest/v1/scores"
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2bXliY3locmJpc2Zqb3VoYnJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk2NzcsImV4cCI6MjA2NDEwNTY3N30.f2t60RjJh91cNlggE_2ViwPXZ1eXP7zD18rWplSI4jE"
    
    private var defaultHeaders: [String: String] {
        [
            "apikey": apiKey,
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Prefer": "return=representation"
        ]
    }
    
    func fetchScores(jwtToken: String, completion: @escaping (Result<[EntradaHistorial], Error>) -> Void) {
        let url = baseURL
        
        let headers: HTTPHeaders = [
            "apikey": apiKey,
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Prefer": "return=representation"
        ]
        
        AF.request(url, headers: headers)
          .validate()
          .responseDecodable(of: [EntradaHistorial].self) { response in
            switch response.result {
            case .success(let scores):
                completion(.success(scores))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }



    
    func guardarPuntaje(
        userId: String?,
        gameId: Int,
        score: Int,
        date: String,
        jwtToken: String,
        completion: @escaping (Result<Void, HTTPClientError>) -> Void
    ) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Headers
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        
        let body: [String: Any] = [
            "user_id": userId ?? "",
            "game_id": gameId,
            "score": score,
            "date": date
        ]
        
        print("🔍 Saving score with body: \(body)")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            completion(.failure(.invalidRequestBody))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error saving score: \(error.localizedDescription)")
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response when saving")
                completion(.failure(.invalidResponse))
                return
            }
            
            print("Save response status: \(httpResponse.statusCode)")
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Save response: \(responseString)")
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("Score saved successfully")
                completion(.success(()))
            } else {
                print("server error saving score: \(httpResponse.statusCode)")
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
            }
        }.resume()
    }
}
