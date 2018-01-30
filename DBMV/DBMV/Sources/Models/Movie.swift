//
//  Movie.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/26.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import Foundation

struct Subject: ModelType {
    let reviewsCount: Int?
    let countries: [String]?
    let ratingsCount: Int?
    let wishCount: Int?
    let casts: [Casts]
    let commentsCount: Int?
    let id: String
    let directors: [Casts]?
    let title: String
    let images: Images
    let scheduleUrl: String?
    let doubanSite: String?
    let mobileUrl: URL?
    let subtype: String?
    let alt: String?
    let shareUrl: URL?
    let genres: [String]
    let rating: Rating
    let summary: String?
    let originalTitle: String?
    let aka: [String]?
    let year: String
    let collectCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case reviewsCount = "reviews_count"
        case countries = "countries"
        case ratingsCount = "ratings_count"
        case wishCount = "wish_count"
        case casts = "casts"
        case commentsCount = "comments_count"
        case id = "id"
        case directors = "directors"
        case title = "title"
        case images = "images"
        case scheduleUrl = "schedule_url"
        case doubanSite = "douban_site"
        case mobileUrl = "mobile_url"
        case subtype = "subtype"
        case alt = "alt"
        case shareUrl = "share_url"
        case genres = "genres"
        case rating = "rating"
        case summary = "summary"
        case originalTitle = "original_title"
        case aka = "aka"
        case year = "year"
        case collectCount = "collect_count"
    }
}


struct Casts: ModelType {
    var avatars: Images?
    var name: String
    var id: String?
    var alt: String?
}

struct Images: ModelType {
    var medium: URL
    var small: URL
    var large: URL
}


struct Rating: ModelType {
    let min: Int
    let stars: String
    let max: Int
    let average: Double
}
