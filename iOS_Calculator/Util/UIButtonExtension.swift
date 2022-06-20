//
//  UIButtonExtension.swift
//  iOS_Calculator
//
//  Created by Manuel Mantilla on 19/06/22.
//  Copyright © 2022 Manuel Mantilla. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    //Voy a usar el naranja por defecto
    //private let myOrange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)
    
    //Borde redondo
    func round() {
        layer.cornerRadius = bounds.height*0.5
        clipsToBounds = true
    }
    
    //Brilla
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) {(completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }
    
    //Apariencia de boton seleccionado
    func selectOperation(_ selected: Bool) {
        backgroundColor = selected ? UIColor.white : UIColor.orange
        setTitleColor(selected ? UIColor.orange : UIColor.white, for: .normal)
    }
}


