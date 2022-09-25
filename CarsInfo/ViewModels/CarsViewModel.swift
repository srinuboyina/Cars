//
//  CarsViewModel.swift
//  CarsInfo
//
//  Created by apple on 17/09/22.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import UIKit

protocol CarsViewModelProtocol {
    var cars: [CarData] {get set}
    var carsObservable: PublishSubject<[CarData]> {get set}
    func fetchCars()
    init(carService: CarServiceProtocol, reachability: ReachabilityProtocol)
}


class CarsViewModel: CarsViewModelProtocol {
    var carService: CarServiceProtocol?
    var cars: [CarData] = []
    var carsObservable = PublishSubject<[CarData]>()
    let reachability: ReachabilityProtocol
    
    required init(carService: CarServiceProtocol = CarService(), reachability: ReachabilityProtocol = Reachability()) {
        self.carService = carService
        self.reachability = reachability
    }
    
    func fetchCars() {
        if reachability.isConnectedToNetwork() {
            carService?.fetchCars(completion: { [weak self] cars in
                self?.cars = cars
                if !DBManager.shared.areCarsAvailable() {
                    for carData in cars {
                        DBManager.shared.save(carData: carData)
                    }
                }
                self?.carsObservable.onNext(cars)
                self?.carsObservable.onCompleted()
            })
        } else {
            cars = DBManager.shared.fetchCarData()
            DispatchQueue.main.async { [weak self] in
                self?.carsObservable.onNext(self?.cars ?? [])
                self?.carsObservable.onCompleted()
            }
        }
    }
}

