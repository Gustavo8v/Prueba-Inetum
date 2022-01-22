//
//  TablePresenter.swift
//  Prueba-EON
//
//  Created by Gustavo on 23/12/21.
//

import UIKit
import FirebaseStorage

class TablePresenter: UIViewController {
    
    private let storage = Storage.storage().reference()
    
    func enabledButton(button: UIButton, image: UIImage?, name: String?) -> Bool{
        var validation = false
        if image != nil && name != "" && name != nil {
            validation = true
        } else {
            validation = false
        }
        return validation
    }
    
    func uploadPhoto(dataImage: Data?, name: String?, successHandler: @escaping(StorageMetadata?) -> Void, errorsHandler: @escaping(Error?) -> Void){
        guard let safeDataImage = dataImage, let safeName = name
        else {
            return
        }
        storage.child("images/\(safeName)").putData(safeDataImage,
                                                    metadata: nil,
                                                    completion: { response, error in
            if error != nil {
                errorsHandler(error)
                return
            } else {
                successHandler(response)
            }
        })
    }
    
    func showAlertController(title:String, message:String, buttons: [UIAlertAction] = [], addContinue: Bool = true, continueHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        for button in buttons {
            alert.addAction(button)
        }
        if addContinue {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: continueHandler))
        }
        return alert
    }
}

enum TypeCellsInformation: Int {
    case name = 0
    case selfie
    case graphics
}

extension UIViewController {
    
}
