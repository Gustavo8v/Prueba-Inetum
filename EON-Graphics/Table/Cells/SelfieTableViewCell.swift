//
//  SelfieTableViewCell.swift
//  Prueba-EON
//
//  Created by Gustavo on 23/12/21.
//

import UIKit

class SelfieTableViewCell: UITableViewCell {
    
    static let identifier = "SelfieTableViewCell"
    
    @IBOutlet weak var cameraButton: UIImageView!
    @IBOutlet weak var labelCamera: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(image: UIImage?){
        if image == nil {
            cameraButton.image = UIImage(systemName: "camera.fill")
        } else {
            cameraButton.image = image
            labelCamera.text = "Selecciona para volver a tomar foto"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
