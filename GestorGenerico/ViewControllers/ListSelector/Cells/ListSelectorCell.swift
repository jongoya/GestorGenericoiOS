//
//  ListSelectorCell.swift
//  GestorHeme
//
//  Created by jon mikel on 02/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ListSelectorCell: UITableViewCell {
    @IBOutlet weak var optionTextLabel: UILabel!
    @IBOutlet weak var listImage: UIImageView!
    
    func setupCell(option: String) {
        listImage.image = UIImage(named: "list_icon")!.withRenderingMode(.alwaysTemplate)
        listImage.tintColor = AppStyle.getPrimaryTextColor()
        optionTextLabel.textColor = AppStyle.getPrimaryTextColor()
        
        optionTextLabel.text = option
    }
}
