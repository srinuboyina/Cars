//
//  ViewController.swift
//  CarsInfo
//
//  Created by apple on 17/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class CarsViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    private var viewModel: CarsViewModelProtocol!
        
    var disposeBag: DisposeBag = DisposeBag()
    
    func setViewModel(viewModel: CarsViewModelProtocol = CarsViewModel()) {
        self.viewModel = viewModel
        self.viewModel.fetchCars()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cars"
        tableView.register(UINib(nibName: "CarCell", bundle: nil), forCellReuseIdentifier: CarCell.Identifier)
        setupCellConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarColor()
    }
    
    func setNavigationBarColor() {
        UINavigationBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.25)
        UINavigationBar.appearance().tintColor = UIColor.black.withAlphaComponent(0.25)
        self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.25)
        self.navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        if #available(iOS 15, *) {
                   let appearance = UINavigationBarAppearance()
                   appearance.configureWithOpaqueBackground()
                   self.navigationController?.navigationBar.isTranslucent = true  // pass "true" for fixing iOS 15.0 black bg issue
                   self.navigationController?.navigationBar.tintColor = UIColor.white // We need to set tintcolor for iOS 15.0
                   appearance.shadowColor = .clear    //removing navigationbar 1 px bottom border.
                   UINavigationBar.appearance().standardAppearance = appearance
                   UINavigationBar.appearance().scrollEdgeAppearance = appearance
               }
    }
    
    func setupCellConfiguration() {
        viewModel.carsObservable
        .bind(to: tableView
          .rx
          .items(cellIdentifier: CarCell.Identifier,
                 cellType: CarCell.self)) { row, car, cell in
                  cell.configureWithCar(car: car)
        }
        .disposed(by: disposeBag)
    }
}

