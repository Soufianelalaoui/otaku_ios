//
//  films.swift
//  otaku_ios
//
//  Created by EL FATHI LALAOUI on 18/01/2022.
//

import Foundation

struct GhibliResponse: Codable {
    let id: String?
    let title: String?
    let original_title: String?
    let image: String?
    let description: String?
    let director: String?
    let producer: String?
    let release_date: String?
    let running_time: String?
    let rt_score: String?
    let people: [String]?
    let species: [String]?
    let locations: [String]?
    let vehicles: [String]?
    let url: String?
}
