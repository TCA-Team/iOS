//
//  LoginViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/5/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var numbersTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var logoView: TUMLogoView?
    var manager: TumDataManager?
    
    @IBAction func skip() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func confirm() {
        PersistentUser.value = .requestingToken(lrzID: getLRZ())
        performSegue(withIdentifier: "waitForConfirmation", sender: self)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if sender === firstTextField {
            handleTextFieldInput(currentTextField: firstTextField,
                                 nextTextField: numbersTextField,
                                 characterLimit: 2)
        } else if sender === numbersTextField {
            handleTextFieldInput(currentTextField: numbersTextField,
                                 previousTextField: firstTextField,
                                 nextTextField: secondTextField,
                                 characterLimit: 2)
        } else if sender === secondTextField {
            handleTextFieldInput(currentTextField: secondTextField,
                                 previousTextField: numbersTextField,
                                 characterLimit: 3)
        }

        confirmButton.isEnabled = textFieldContentsAreValid()
        confirmButton.alpha = textFieldContentsAreValid() ? 1 : 0.5
        confirmButton.backgroundColor = Constants.tumBlue
    }

    private func handleTextFieldInput(currentTextField: UITextField, previousTextField: UITextField? = nil, nextTextField: UITextField? = nil, characterLimit: Int) {
        let text = currentTextField.text ?? ""

        if text.count >= characterLimit {
            currentTextField.text = String(text.prefix(characterLimit))

            let substring = String(text.characters.dropFirst(characterLimit))
            if let nextTextField = nextTextField {
                nextTextField.becomeFirstResponder()
                if !substring.isEmpty {
                    nextTextField.text = substring
                    textFieldEditingChanged(nextTextField)
                }
            } else {
                currentTextField.resignFirstResponder()
            }
        } else if text.isEmpty {
            guard let previousTextField = previousTextField else { return }

            previousTextField.becomeFirstResponder()
        }
    }

    func textFieldContentsAreValid() -> Bool {
        guard let firstText = firstTextField.text, firstText.count == 2,
            let numbersText = numbersTextField.text, numbersText.count == 2,
            let secondText = secondTextField.text, secondText.count == 3 else { return false }

        let isFirstTextValid = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: firstText))
        let isNumbersTextValid = Int(numbersText) != nil
        let isSecondTextValid = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: secondText))

        highlightTextfield(textField: firstTextField, isHighlighted: !isFirstTextValid)
        highlightTextfield(textField: numbersTextField, isHighlighted: !isNumbersTextValid)
        highlightTextfield(textField: secondTextField, isHighlighted: !isSecondTextValid)

        return isFirstTextValid && isNumbersTextValid && isSecondTextValid
    }

    private func highlightTextfield(textField: UITextField, isHighlighted: Bool) {
        textField.layer.borderWidth = isHighlighted ? 1 : 0
        textField.layer.borderColor = isHighlighted ? UIColor.red.cgColor : UIColor(hexString: "0xC7C7CD").cgColor
    }
    
    private func setupLogo() {
        let bundle = Bundle.main
        let nib = bundle.loadNibNamed("TUMLogoView", owner: nil, options: nil)?.flatMap { $0 as? TUMLogoView }
        guard let view = nib?.first else { return }
        logoView = view
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.titleView = view
    }
}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PersistentUser.hasEnteredID {
            performSegue(withIdentifier: "waitForConfirmation", sender: self)
        }
        
        firstTextField.becomeFirstResponder()

        confirmButton.setTitle("🍻", for: .normal)
        confirmButton.setTitle("🎓", for: .disabled)

       setupLogo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
    }
    
}

extension LoginViewController {

    func getLRZ() -> String {
        if let first = firstTextField.text, let numbers = numbersTextField.text, let second = secondTextField.text {
            return first + numbers + second
        }
        return ""
    }
}


extension LoginViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return manager
    }
    
}
