//
//  RequestService.swift
//  Navigation


import Foundation
//Задача 2 задание 2

struct UrlName {
    static let baseUrl = "https://swapi.dev/api/planets/1"
}

struct Residents: Decodable {
    let name: String
}

struct Planet: Decodable {
    let name: String
    let orbitalPeriod: String
    let residents: [URL]
    
    enum CodingKeys: String, CodingKey {
        case name
        case orbitalPeriod = "orbital_period"
        case residents
    }
    
    static func requestPlanets(completion: @escaping (Result<Planet, Error>) -> Void) {
        
        guard let url = URL(string: UrlName.baseUrl) else { return }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ОШИБКА - ",error.localizedDescription)
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("Успешный запрос")
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let planet = try decoder.decode(Planet.self, from: data)
                            print(planet)
                            completion(.success(planet))
                        } catch {
                            print("Ошибка декодирования \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                case 404:
                    print("Страница не найдена")
                default:
                    print("-", httpResponse.statusCode)
                }
            }
        }
        dataTask.resume()
    }
}




