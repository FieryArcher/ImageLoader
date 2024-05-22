//
//  ItemModel.swift
//  ImageLoader
//
//  Created by Nurlan Darzhanov on 20.05.2024.
//

import Foundation

struct ItemModel: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
