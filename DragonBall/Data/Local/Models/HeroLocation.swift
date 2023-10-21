//
//  HeroLocation.swift
//  DragonBalliOSAvanzado
//
//  Created by Pedro on 21/10/23.
//

import Foundation

typealias HeroLocations = [HeroLocation]

struct HeroLocation: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case hero
        case latitude = "latitud"
        case longitude = "longitud"
        case date = "dateShow"
    }

    let id: String?
    let latitude: String?
    let longitude: String?
    let date: String?
    let hero: Hero?
}
