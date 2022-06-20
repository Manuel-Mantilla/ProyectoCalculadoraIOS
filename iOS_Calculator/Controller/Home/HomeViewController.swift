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
    private let kTotal = "total"
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    //private let kMaxValue: Double = 999999999 //Se elimina por el nuevo formato científico
    //private let kMinValue = 0.00000001 //Se elimina por el nuevo formato científico
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
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    //Formateo de valores auxiliares, formato cientifico
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
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
        total = UserDefaults.standard.double(forKey: kTotal)
        
        result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Elementos de la interfaz gráfica (botones)
        num0.round()
        num1.round()
        num2.round()
        num3.round()
        num4.round()
        num5.round()
        num6.round()
        num7.round()
        num8.round()
        num9.round()
        dot.round()
        operaAC.round()
        operaPositiveNegative.round()
        operaPercent.round()
        operaAddition.round()
        operaSubstraction.round()
        operaMultiplication.round()
        operaDivision.round()
        operaEqual.round()
    }
    
    //MARK: - Button actions
    @IBAction func operaACAction(_ sender: UIButton) {
        clear()
        
        sender.shine()
    }
    @IBAction func operaPositiveNegativeAction(_ sender: UIButton) {
        temp *= (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
    }
    @IBAction func operaPercentAction(_ sender: UIButton) {
        if operation != .percent {
            result()
        }
        operating =  true
        operation = .percent
        result()
        
        sender.shine()
    }
    @IBAction func operaEqualAction(_ sender: UIButton) {
        result()
        
        sender.shine()
    }
    @IBAction func operaAditionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .addition
        
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operaSubstractionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .substraction
        
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operaMultiplicationAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .multiplication
        
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operaDivisionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .division
        
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func dotAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        
        selectVisualOperation()
        sender.shine()
    }
    @IBAction func numberAction(_ sender: UIButton) {
        operaAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
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
        
        selectVisualOperation()
        sender.shine()
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
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        //Ya no necesitamos esta parte poque eliminamos las constantes kMax-kMin
        //if total <= kMaxValue || total >= kMinValue {
        //  resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        //}
        
        selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        print("TOTAL: \(total)")
    }
    
    //Para resaltar la última operación seleccionada
    func selectVisualOperation() {
        if operating {
            switch operation {
                case .addition:
                    operaAddition.selectOperation(true)
                    operaSubstraction.selectOperation(false)
                    operaMultiplication.selectOperation(false)
                    operaDivision.selectOperation(false)
                    break
                case .substraction:
                    operaAddition.selectOperation(false)
                    operaSubstraction.selectOperation(true)
                    operaMultiplication.selectOperation(false)
                    operaDivision.selectOperation(false)
                    break
                case .multiplication:
                    operaAddition.selectOperation(false)
                    operaSubstraction.selectOperation(false)
                    operaMultiplication.selectOperation(true)
                    operaDivision.selectOperation(false)
                    break
                case .division:
                    operaAddition.selectOperation(false)
                    operaSubstraction.selectOperation(false)
                    operaMultiplication.selectOperation(false)
                    operaDivision.selectOperation(true)
                    break
                case .none, .percent:
                    operaAddition.selectOperation(false)
                    operaSubstraction.selectOperation(false)
                    operaMultiplication.selectOperation(false)
                    operaDivision.selectOperation(false)
                    break
            }
        } else {
            //No estamos operando
            operaAddition.selectOperation(false)
            operaSubstraction.selectOperation(false)
            operaMultiplication.selectOperation(false)
            operaDivision.selectOperation(false)
        }
    }

}
