//
//  RatingAndReviewModel.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 11/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation

struct RatingAndReviewModel: Codable {
    let author: AuthorModel
    let version: ReusableModel
    let rating: ReusableModel
    let title: ReusableModel
    let content: ReusableModel
    
    enum CodingKeys: String, CodingKey {
        case author
        case version = "im:version"
        case rating = "im:rating"
        case title
        case content
    }
}

struct AuthorModel: Codable {
    let name: ReusableModel
}

struct ReusableModel: Codable {
    let label: String
}
