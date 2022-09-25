//
//  CarData.swift
//  CarsInfo
//
//  Created by apple on 17/09/22.
//

import Foundation

struct CarMetaData: Decodable {
    var status: String
    var content: [CarData]
}

struct CarData: Decodable {
    var title: String
    var image: String
    var dateTime: String
    var ingress: String
    var imageData: Data?
    
}
