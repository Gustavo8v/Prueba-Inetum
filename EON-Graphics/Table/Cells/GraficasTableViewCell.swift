//
//  GraficasTableViewCell.swift
//  Prueba-EON
//
//  Created by Gustavo on 23/12/21.
//

import UIKit

class GraficasTableViewCell: UITableViewCell {
    
    static let identifier = "GraficasTableViewCell"
    
    @IBOutlet weak var questionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(data: QuestionsModel){
        questionLabel.text = data.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
