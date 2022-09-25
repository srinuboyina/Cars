//
//  DBManager.swift
//  CarsInfo
//
//  Created by apple on 23/09/22.
//

import UIKit
import Foundation
import CoreData

class DBManager {
    static let shared = DBManager()
    
    func areCarsAvailable() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Car")
        do {
            _ = try managedContext.fetch(fetchRequest)
            return true
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func fetchCarData() -> [CarData]{
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return []
          }
          let managedContext = appDelegate.persistentContainer.viewContext
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Car")
          do {
              let carsData = try managedContext.fetch(fetchRequest)
              return self.prepareCarsData(carsData: carsData)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
              return []
          }

    }
    
    private func prepareCarsData(carsData: [NSManagedObject]) -> [CarData] {
        var localCars: [CarData] = []
        for car in carsData {
            if let title = car.value(forKey: "title") as? String,
               let imageData = car.value(forKey: "image") as? Data,
               let dateTime = car.value(forKey: "dateTime") as? String,
               let ingress = car.value(forKey: "ingress") as? String {
               let lCar = CarData(title: title, image: "", dateTime: dateTime, ingress: ingress, imageData: imageData)
                localCars.append(lCar)
            }
        }
        return localCars
    }
    
    func save(carData: CarData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Car",
                                                in: managedContext)!
        
        let queue = DispatchQueue(label: "coredata.save", attributes: .concurrent)
        queue.async {
            let car = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
            car.setValue(carData.title, forKeyPath: "title")
            let data = try! Data(contentsOf: URL(string: carData.image)!)
            car.setValue(data, forKeyPath: "image")
            car.setValue(carData.dateTime, forKeyPath: "dateTime")
            car.setValue(carData.ingress, forKeyPath: "ingress")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}
