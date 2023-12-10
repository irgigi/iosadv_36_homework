//
//  NetworkManager.swift
//  Navigation


import UIKit


enum AppConfiguration: CaseIterable {
    
    case url1
    case url2
    case url3
    
    var urlString: String {
        switch self {
        case .url1:
            return "https://swapi.dev/api/people/1/"
        case .url2:
            return "https://swapi.dev/api/planets/1"
        case .url3:
            return "https://swapi.dev/api/starships/9"
        }
    }
}

struct NetworkManager {
    
    //метод запускает URLSessionDataTask для определенного URL
    static func request(for configuration: AppConfiguration) {
        let urlString = String(configuration.urlString)
        print("urlString -", urlString)
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // при выключенном интернете - ОШИБКА -  The Internet connection appears to be offline.
            if let error = error {
                print("ОШИБКА - ",error.localizedDescription)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("Успешный запрос")
                    guard let data = data else { return }
                    guard let dataString = String(data: data, encoding: .utf8) else { return }
                    print(dataString)
                case 404:
                    print("Страница не найдена")
                default:
                    print("-", httpResponse.statusCode)
                }
                
                if let headers = httpResponse.allHeaderFields as? [String: String] {
                    for (key, value) in headers {
                        switch key {
                        case "Content-Type":
                            print(value)
                        case "Server":
                            print(value)
                        default:
                            print(httpResponse.allHeaderFields)
                        }
                    }
                }
            }
        }
        dataTask.resume()
    }
    
}
