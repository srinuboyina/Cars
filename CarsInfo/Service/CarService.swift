//
//  CarService.swift
//  CarsInfo
//
//  Created by apple on 17/09/22.
//

import Foundation
import CoreData

protocol CarServiceProtocol {
    func fetchCars(completion: @escaping (([CarData])->Void))
}

class CarService: CarServiceProtocol {
    func fetchCars(completion: @escaping (([CarData])->Void)) {
        NetworkLayer.shared.fetchApiData(urlString: APIConfig.carsAPI.rawValue) { (cars: CarMetaData?, error: ErrorModel?) in
            if let cars = cars {
                completion(cars.content)
            } else {
                //show error
            }
        }
    }
}
