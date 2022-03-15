//
//  ViewController.swift
//  ColorChangeApp
//
//  Created by VG on 10.03.2022.
//

import UIKit

class ColorViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    // MARK: - Public Properties
    var delegate: ColorViewControllerDelegate!
    var viewColor: UIColor!
    
    //MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 10
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        colorView.backgroundColor = viewColor
        
        setColor()
        setValue(for: redLabel, greenLabel, blueLabel)
        setValue(for: redTextField, greenTextField, blueTextField)
    }
    
    //MARK: - IB Actions
    @IBAction func rgbSlider(_ sender: UISlider) {
        
        switch sender {
        case redSlider:
            setValue(for: redLabel)
            setValue(for: redTextField)
        case greenLabel:
            setValue(for: greenLabel)
            setValue(for: greenTextField)
        default:
            setValue(for: blueLabel)
            setValue(for: blueTextField)
        }
        
        setColor()
    }
    
    @IBAction func doneButtonPressed() {
        delegate.setColor(colorView.backgroundColor ?? .blue)
        dismiss(animated: true)
    }
}
    
    // MARK: - Private Methods
extension ColorViewController {
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue(for labels: UILabel...) {
        labels.forEach {label in
            switch label {
            case redLabel: label.text = string(from: redSlider)
            case greenLabel: label.text = string(from: greenSlider)
            default: label.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        textFields.forEach {textField in
            switch textField {
            case redTextField: textField.text = string(from: redSlider)
            case greenTextField: textField.text = string(from: greenSlider)
            default: textField.text = string(from: blueSlider)
            }
        }
    }
    
    private func setSliders() {
        let ciColor = CIColor(color: viewColor)
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
    
    // Значения RGB
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    // Метод отвечает за скрытие клавиатуры
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
    // Прописываем всплывашки, на случай если пользователь ошибется
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
        
    // MARK: - UITextFieldDelegate
    extension ColorViewController: UITextFieldDelegate {
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            view.endEditing(true)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            guard let text = textField.text else { return }
            
            if let currentValue = Float(text) {
                switch textField {
                case redTextField:
                    redSlider.setValue(currentValue, animated: true)
                    setValue(for: redLabel)
                case greenTextField:
                    greenSlider.setValue(currentValue, animated: true)
                    setValue(for: greenLabel)
                default:
                    blueSlider.setValue(currentValue, animated: true)
                    setValue(for: blueLabel)
                }
                setColor()
            }
            
            showAlert(title: "Wrong format!", message: "Please enter correct value")
        }
        
        /* Это для обычной клавиатуры
         func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == redTextField {
                greenTextField.becomeFirstResponder()
            }
            if textField == greenTextField {
                blueTextField.becomeFirstResponder()
            }
            return true
        }
         */
        
        // Для клавы с цифрами, по умолчанию в ней нет толбара, надо его прописать вот так...
        func textFieldDidBeginEditing(_ textField: UITextField) {
            let keyboardToolbar = UIToolbar()
            keyboardToolbar.sizeToFit() //Свойство ".sizeToFit", означает встроить наш тулбар по содержимому
            textField.inputAccessoryView = keyboardToolbar //Здесь мы говорим что текстовое поле будет иметь аксессуар в виде нашего тулбара
            
            // В это клаве нет кнопки done, надо ее сделать вот так, по умолчанию эта кнопка будет располагаться слева
            let doneButton = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self, //мы говори что в этом классе будет вызван этот метод (target, то есть цель) target для метода didTapDone
                action: #selector(didTapDone)
            )
            
            // Чтобы переметить кнопку done вправо, с левой стороны надо расположить flexBarButton, свойство ".flexibleSpace" говорит, что flexBarButton займет все свободное пространство с левой стороны
            let flexBarButton = UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            )
            
            // Теперь мы помещаем наши кнопки в массив тулбара, в том порядке, кокой хотим видеть на экране
            keyboardToolbar.items = [flexBarButton, doneButton]
        }
    }

