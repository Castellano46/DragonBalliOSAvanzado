//
//  ApiProvider.swift
//  DragonBalliOSAvanzado
//
//  Created by Pedro on 11/10/23.
//

import Foundation

extension NotificationCenter {
    static let apiLoginNotification = Notification.Name("NOTIFICATION_API_LOGIN")
    static let tokenKey = "KEY_TOKEN"
}

protocol ApiProviderProtocol {
    func login(for user: String, with password: String)
    func getHeroes(by name: String?, token: String, completion: ((Heroes) -> Void)?)
    func getLocations(by heroId: String?, token: String, completion: ((HeroLocations) -> Void)?)
}

class ApiProvider: ApiProviderProtocol {
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"
    private enum Endpoint {
        static let login = "/auth/login"
        static let heroes = "/heros/all"
        static let heroLocations = "/heros/locations"
    }

    func login(for user: String, with password: String) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.login)") else {
            return
        }

        guard let loginData = String(format: "%@:%@",
                                     user, password).data(using: .utf8)?.base64EncodedString() else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)",
                            forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                return
            }

            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                return
            }

            guard let responseData = String(data: data, encoding: .utf8) else {
                return
            }

            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: [NotificationCenter.tokenKey: responseData]
            )
        }.resume()
    }

    func getHeroes(by name: String?, token: String, completion: ((Heroes) -> Void)?) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.heroes)") else {
            return
        }

        let jsonData: [String: Any] = ["name": name ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)",
                            forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion?([])
                return
            }

            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?([])
                return
            }

            guard let heroes = try? JSONDecoder().decode(Heroes.self, from: data) else {
                completion?([])
                return
            }

            print("API RESPONSE - GET HEROES: \(heroes)")
            completion?(heroes)
        }.resume()
    }
    
    func getLocations(by heroId: String?, token: String, completion: ((HeroLocations) -> Void)?) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.heroLocations)") else {
            return
        }

        let jsonData: [String: Any] = ["id": heroId ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)",
                            forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion?([])
                return
            }

            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?([])
                return
            }

            guard let heroLocations = try? JSONDecoder().decode(HeroLocations.self, from: data) else {
                completion?([])
                return
            }

            print("API RESPONSE - GET HERO LOCATIONS: \(heroLocations)")
            completion?(heroLocations)
        }.resume()
    }
}
