//
//  PickerTableCell.swift
//  ColorWheel
//
//  Created by Jayesh Tejwani on 05/04/22.
//

import UIKit

class PickerTableCell: UITableViewCell {

    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet  var btnColors : [UIButton]!
    
    @IBOutlet weak var sliderOpacity: UISlider!
    @IBOutlet weak var lblBrightness: UILabel!
    
    weak var parent: ColorPickerVC!
    
    func prepareCell(ind: Int) {
        if ind == 1 {
            sliderOpacity.value = parent.opacity
            lblBrightness.text = "\(Int(parent.opacity))%"
        } else if ind == 2 {
            prepareColorUI()
        }
    }
    
    func prepareColorUI() {
        colorPicker.set(color: UIColor(displayP3Red: 1.0, green: 1.0, blue: 0, alpha: 1), colorSpace: .sRGB)
        colorPicker.addTarget(self, action: #selector(self.handleColorChanged(picker:)), for: .valueChanged)
    }
    
    @objc func handleColorChanged(picker: ColorPicker) {
        let alpha = CGFloat(parent.opacity / 100)
        let clr = picker.color.withAlphaComponent(alpha)
        if let cell = parent.getPickerCell(row: 0) {
            cell.btnColors[parent.currentSegment].backgroundColor = clr
        }
    }
}
