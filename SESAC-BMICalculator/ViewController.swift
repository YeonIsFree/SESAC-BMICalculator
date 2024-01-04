//
//  ViewController.swift
//  SESAC-BMICalculator
//
//  Created by Seryun Chun on 2024/01/03.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    @IBOutlet var nicknameTextField: UITextField!
    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var validCheckLabel: UILabel!
    
    @IBOutlet var secureButton: UIButton!
    
    @IBOutlet var randomButton: UIButton!
    
    @IBOutlet var saveMyDataButton: UIButton!
    
    @IBOutlet var loadMyDataButton: UIButton!
    
    @IBOutlet var resetMyDataButton: UIButton!
    
    @IBOutlet var resultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationUI()
    }
    
    @IBAction func resultButtonTapped(_ sender: UIButton) {
        // 안내 문구 초기화
        hideValidCheckLabel()
        
        // 텍스트필드 Optional 해제
        guard let userHeight = heightTextField.text else { return }
        guard let userWeight = weightTextField.text else { return }

        // 숫자가 들어왔는지 검사 - 공백이나 문자이면 안내 문구
        guard let userHeight = Double(userHeight) else {
            showValidCheckLabel()
            return
        }
        guard let userWeight = Double(userWeight) else {
            showValidCheckLabel()
            return
        }
        
        // 정상적인 숫자인지 검사 - 범위 벗어나면 안내 문구
        let isValidNum = isNumberInValidRange(height: userHeight, weight: userWeight)
        if !isValidNum {
            showValidCheckLabel()
            return
        }
        
        // bmi 계산
        let meterHeight = converToMeter(number: userHeight)
        let bmi = calculateBMI(height: meterHeight, weight: userWeight)
        let result = getBMIResult(bmi)
        
        // 결과 Alert 표시
        presentResultAlert(bmi, result)
    }
    
    @IBAction func resetMyDataButtonTapped(_ sender: UIButton) {
        // Data Remove
        UserDefaults.standard.removeObject(forKey: "nickname")
        UserDefaults.standard.removeObject(forKey: "height")
        UserDefaults.standard.removeObject(forKey: "weight")
        
        // Remove Alert
        presentAlert(text: "사용자 데이터가 초기화 되었습니다!")
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        let randomHeight = Double.random(in: 100...200)
        let randomWeight = Double.random(in: 30...150)

        setRandomData(randomHeight, randomWeight)
    }
    
    @IBAction func loadMyDataButtonTapped(_ sender: UIButton) {
        // Data Load
        let nickname = loadMyData("nickname")
        let userHeight = loadMyData("height")
        let userWeight = loadMyData("weight")
        
        // Set Data
        nicknameTextField.text = nickname
        heightTextField.text = userHeight
        weightTextField.text = userWeight
    }
    
    @IBAction func saveMyDataButtonTapped(_ sender: UIButton) {
        // Save
        guard let nickname = nicknameTextField.text else { return }
        guard let userHeight = heightTextField.text else { return }
        guard let userWeight = weightTextField.text else { return }
        
        saveMyData("nickname", nickname)
        saveMyData("height", userHeight)
        saveMyData("weight", userWeight)
 
        // Save Alert
        presentAlert(text: "저장 되었습니다!")
    }
    
    func converToMeter(number: Double) -> Double {
        return number * 0.01
    }
    
    // --- keyboard dismiss
    @IBAction func keyboardDismiss(_ sender: Any) {
    }
    
    @IBAction func tapGestureKeyboardDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // --- User Default   String : String
    func loadMyData(_ key: String) -> String {
        if let value = UserDefaults.standard.string(forKey: "\(key)") {
            return value
        }
        return "ERROR"
    }

    func saveMyData(_ key: String, _ value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // --- validation
    func isNumberInValidRange(height: Double, weight: Double) -> Bool {
        var isValidHeight: Bool
        var isValidWeight: Bool
        // Height check
        if 100 <= height && height <= 200 {
            isValidHeight = true
        } else {
            isValidHeight = false
        }
        
        // Weight check
        if 30 <= weight && weight <= 150 {
            isValidWeight = true
        } else {
            isValidWeight = false
        }
        
        // result check
        return isValidHeight && isValidWeight
    }
    
    func hideValidCheckLabel() {
        validCheckLabel.isHidden = true
    }

    func showValidCheckLabel() {
        validCheckLabel.isHidden = false
    }
    
    // --- BMI Logic
    func calculateBMI(height: Double, weight: Double) -> Double {
        return weight / (height * height)
    }
    
    func getBMIResult(_ bmi: Double) -> String {
        var result = ""
        if bmi < 18.5 {
            result = "저체중"
        } else if 18.5 <= bmi && bmi < 23 {
            result = "정상"
        } else if 23 <= bmi && bmi < 25 {
            result = "위험 체중"
        } else if 25 <= bmi {
            result = "비만"
        }
        return result
    }
    
    // --- Random Logic
    func setRandomData(_ height: Double, _ weight: Double) {
        heightTextField.text = "\(String(format: "%.0f", height))"
        weightTextField.text = "\(String(format: "%.0f", weight))"
    }
    
    // --- Alert
    func presentResultAlert(_ bmi: Double, _ result: String) {
        let alert = UIAlertController(title: nil, message: "BMI 지수 : \(Int(bmi))\n\(result) 입니다.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func presentAlert(text: String) {
        let alert = UIAlertController(title: nil, message: "\(text)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }

    // --- UI design
    func configurationUI() {
        configurationTitleLabel()
        configurationSubTitleLabel()
        configurationMainImageView()
        configurationTextFieldLabel(heightLabel, "키(cm)")
        configurationTextFieldLabel(weightLabel, "몸무게(kg)")
        configurationNicknameTextField()
        configurationTextField(heightTextField)
        configurationTextField(weightTextField)
        cofigurationValidCheckLabel()
        configureSecureButton()
        configurationRandomButton()
        configurationResultButton()
        configurationMyDataButton(resetMyDataButton, title: "Reset")
        configurationMyDataButton(loadMyDataButton, title: "Load")
        configurationMyDataButton(saveMyDataButton, title: "Save")
    }
    
    func configurationMainImageView() {
        mainImageView.image = UIImage(named: "image")
    }
    
    func configurationTitleLabel() {
        titleLabel.text = "BMI Calculator"
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
    }
    
    func configurationSubTitleLabel() {
        subTitleLabel.text = "당신의 BMI 지수를 알려드릴게요."
        subTitleLabel.numberOfLines = 2
    }
    
    func configurationNicknameTextField() {
        configurationTextField(nicknameTextField)
        nicknameTextField.placeholder = " 이름을 알려주세요!"
    }
    
    func configurationTextFieldLabel(_ label: UILabel, _ target: String) {
        label.text = "   " + target + "가 어떻게 되시나요?"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .darkGray
    }
    
    func configurationTextField(_ textField: UITextField) {
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func cofigurationValidCheckLabel() {
        validCheckLabel.text = "   키와 몸무게를 올바르게 입력해주세요"
        validCheckLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        validCheckLabel.textColor = .systemRed
        validCheckLabel.isHidden = true
    }
    
    func configureSecureButton() {
        let img = UIImage(systemName: "eye.slash")
        secureButton.setImage(img, for: .normal)
        secureButton.setTitle(nil, for: .normal)
        secureButton.tintColor = .darkGray
    }
    
    func configurationRandomButton() {
        randomButton.setTitle("랜덤으로 BMI 계산하기 ", for: .normal)
        randomButton.setTitleColor(.systemBlue, for: .normal)
        randomButton.titleLabel?.font = .systemFont(ofSize: 15)
    }
    
    func configurationMyDataButton(_ button: UIButton, title: String) {
        button.setTitle("\(title)", for: .normal)
        button.setTitleColor(.systemPurple, for: .normal)
    }
    
    func configurationResultButton() {
        resultButton.backgroundColor = .purple
        resultButton.setTitle("결과 확인", for: .normal)
        resultButton.tintColor = .white
        resultButton.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        resultButton.clipsToBounds = true
        resultButton.layer.cornerRadius = 15
    }

}

