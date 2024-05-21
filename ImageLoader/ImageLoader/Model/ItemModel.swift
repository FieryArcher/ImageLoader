//
//  ItemModel.swift
//  ImageLoader
//
//  Created by Nurlan Darzhanov on 20.05.2024.
//

import Foundation


struct Items: Decodable {
    var data: [ItemModel]
}

struct ItemModel: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}


//{
//        "albumId": 1,
//        "id": 1,
//        "title": "accusamus beatae ad facilis cum similique qui sunt",
//        "url": "https://via.placeholder.com/600/92c952",
//        "thumbnailUrl": "https://via.placeholder.com/150/92c952"
//    }
