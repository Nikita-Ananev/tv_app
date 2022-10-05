//
//  Channel.swift
//  testWorkLimex
//
//  Created by Никита Ананьев on 29.09.2022.
//

import UIKit

struct ResultJson: Codable {
    let channels: [Channel]
}
struct Channel: Codable {
    
    let id: Int
    let image: String
    let name_ru: String
    let current: Broadcast
    let url: String
}
struct Broadcast: Codable {
    let title: String
    let desc: String
    let timestart: Int
    let timestop: Int
}
