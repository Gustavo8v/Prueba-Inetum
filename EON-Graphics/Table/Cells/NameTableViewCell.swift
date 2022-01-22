//
//  NameTableViewCell.swift
//  Prueba-EON
//
//  Created by Gustavo on 23/12/21.
//

protocol NameTableViewCellDelegate: AnyObject {
    func saveName(name: String)
}

import UIKit

class NameTableViewCell: UITableViewCell {
    
    static let identifier = "NameTableViewCell"
    weak var delegate: NameTableViewCellDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
        nameTextField.keyboardType = .alphabet
    }
    
    func configureName(name: String?){
        if name == nil {
            nameTextField.text = ""
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension NameTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if range.location == 0 && string == " " { // prevent space on first character
            return false
        }

        if textField.text?.last == " " && string == " " { // allowed only single space
            return false
        }

        if string == " " { return true } // now allowing space between name

        if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
            return false
        }

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.saveName(name: textField.text ?? "")
        return true
    }
}
