//
//  HomeViewController.swift
//  iOS_Calculator
//
//  Created by Manuel Mantilla on 2/06/22.
//  Copyright © 2022 Manuel Mantilla. All rights reserved.
//

import UIKit

//final: para que la clase no se extienda?
final class HomeViewController: UIViewController {

    //MARK: - Outlets
    //Result
    @IBOutlet weak var resultLabel: UILabel!
    //Numbers
    @IBOutlet weak var num0: UIButton!
    @IBOutlet weak var num1: UIButton!
    @IBOutlet weak var num2: UIButton!
    @IBOutlet weak var num3: UIButton!
    @IBOutlet weak var num4: UIButton!
    @IBOutlet weak var num5: UIButton!
    @IBOutlet weak var num6: UIButton!
    @IBOutlet weak var num7: UIButton!
    @IBOutlet weak var num8: UIButton!
    @IBOutlet weak var num9: UIButton!
    @IBOutlet weak var dot: UIButton!
    //Operators
    @IBOutlet weak var operaAC: UIButton!
    @IBOutlet weak var operaPositiveNegative: UIButton!
    @IBOutlet weak var operaPercent: UIButton!
    @IBOutlet weak var operaEqual: UIButton!
    @IBOutlet weak var operaAddition: UIButton!
    @IBOutlet weak var operaSubstraction: UIButton!
    @IBOutlet weak var operaMultiplication: UIButton!
    @IBOutlet weak var operaDivision: UIButton!
    
    //MARK: - Variables
    private var total: Double = 0 //Total
    private var temp: Double = 0 //Valor temporal para mostrar en pantalla
    private var operating: Bool = false //Para indicar si se señalo una opeacion
    private var decimal: Bool = false //Para indicar si se usó punto
    private var operation: OperationType = .none //Indica la operación a realizar
    
    
    //MARK: - Constants
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMagLength = 9
    private let kMaxValue: Double = 999999999
    private let kMinValue = 0.00000001
    private enum OperationType {
        case none, addition, substraction, multiplication, division, percent
    }
    
    //MARK: - Formatter
    //Formateo de valores auxiliares
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    //Formato de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    //Formato de valores por pantalla en formato cientifico
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    //MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dot.setTitle(kDecimalSeparator, for: .normal)
        result()
    }
    
    //MARK: - Button actions
    @IBAction func operaACAction(_ sender: UIButton) {
        clear()
    }
    @IBAction func operaPositiveNegativeAction(_ sender: UIButton) {
        temp *= (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
    }
    @IBAction func operaPercentAction(_ sender: UIButton) {
        if operation != .percent {
            result()
        }
        operating =  true
        operation = .percent
        result()
    }
    @IBAction func operaEqualAction(_ sender: UIButton) {
        result()
    }
    @IBAction func operaAditionAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .addition
    }
    @IBAction func operaSubstractionAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .substraction
    }
    @IBAction func operaMultiplicationAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .multiplication
    }
    @IBAction func operaDivisionAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .division
    }
    @IBAction func dotAction(_ sender: UIButton) {
        let currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMagLength {
            return
        }
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
    }
    @IBAction func numberAction(_ sender: UIButton) {
        operaAC.setTitle("C", for: .normal)
        var currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMagLength {
            return
        }
        //Hemos seleccionado una operación
        if operating {
            total = total == 0 ? temp:total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        //Hemos seleccionado un decimal
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
    }
    
    //Limpia los valores
    private func clear() {
        operation = .none
        operaAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        } else {
            total = 0
            result()
        }
    }
    
    private func result() {
        switch operation {
        
        case .none:
            //No hacemos nada
            break
        case .addition:
            total += temp
            break
        case .substraction:
            total -= temp
            break
        case .multiplication:
            total *= temp
            break
        case .division:
            total /= temp
            break
        case .percent:
            temp = temp/100
            total = temp
            break
        }
        
        //Formateo en pantalla
        if total <= kMaxValue || total >= kMinValue {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        print("TOTAL: \(total)")
    }

}
