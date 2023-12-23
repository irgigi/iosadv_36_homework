//
//  JSONModel.swift
//  Navigation


import Foundation
//Задача 1 задание 2
struct JSONModel {
    static func request(completion: @escaping (Result<String, Error>) -> Void) {
        let stringURL = "https://jsonplaceholder.typicode.com/todos/25"
        guard let url = URL(string: stringURL) else { return }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
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
                    do {
                        guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                        if let userId = jsonDictionary["userId"] as? Int {
                            print("userId - \(userId)")
                        }
                        if let id = jsonDictionary["id"] as? Int {
                            print("id - \(id)")
                        }
                        if let title = jsonDictionary["title"] as? String {
                            print("title - \(title)")
                            completion(.success(title))
                        }
                        if let completed = jsonDictionary["completed"] as? Bool {
                            print("completed - \(completed)")
                        }
                    } catch {
                        print("Ошибка при десериализации JSON \(error.localizedDescription)")
                        completion(.failure(error))
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



