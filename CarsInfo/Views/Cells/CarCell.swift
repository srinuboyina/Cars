//
//  CarCell.swift
//  CarsInfo
//
//  Created by apple on 17/09/22.
//

import UIKit
import CoreData

class CarCell: UITableViewCell {
    
    static let Identifier = "CarCell"
    
    @IBOutlet internal var carImageView: ImageLoader!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateTimeLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGradient()
    }
    
    func setGradient() {
        let colors = [UIColor.clear, UIColor.black]
        contentView.applyGradient(isVertical: true, colorArray: colors)
    }
    
    func configureWithCar(car: CarData) {
        if !car.image.isEmpty, let url = URL(string: car.image) {
            carImageView.loadImageWithUrl(url)
        } else if let data = car.imageData {
            carImageView.image = UIImage(data: data)
        }
        titleLabel.text = car.title
        dateTimeLabel.text = car.dateTime
        descriptionLabel.text = car.ingress
    }
}


extension UIView {

    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
