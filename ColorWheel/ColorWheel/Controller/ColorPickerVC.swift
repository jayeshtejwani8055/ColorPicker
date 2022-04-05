//
//  ColorPickerVC.swift
//  ColorWheel
//
//  Created by Jayesh Tejwani on 05/04/22.
//

import UIKit

class ColorPickerVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var opacity: Float = 80.0
    var currentSegment = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setSelectedSegment(ind: 0)
    }
}

extension ColorPickerVC {
    
    func prepareUI() {
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func getPickerCell(row: Int) -> PickerTableCell? {
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? PickerTableCell
        return cell
    }
    
    func changeColor(color: UIColor) {
        if let cell = getPickerCell(row: 2) {
            cell.colorPicker.set(color: color, colorSpace: .sRGB)
        }
    }
    
    func setSelectedSegment(ind: Int) {
        if let cell = getPickerCell(row: 0) {
            for(idx,btn) in cell.btnColors.enumerated() {
                if idx == ind {
                    btn.layer.borderColor = UIColor.white.cgColor
                    btn.layer.borderWidth = 2.0
                } else {
                    btn.layer.borderColor = nil
                    btn.layer.borderWidth = 0.0
                }
            }
        }
    }
}

extension ColorPickerVC {
    
    @IBAction func btnChangeColorTapped(_ sender: UIButton) {
        currentSegment = sender.tag
        let color = sender.backgroundColor ?? UIColor.white
        changeColor(color: color)
        setSelectedSegment(ind: currentSegment)
    }
    
    @IBAction func sliderBrightnessChanged(_ sender: UISlider) {
        opacity = sender.value.rounded()
        if let cell = getPickerCell(row: 0) {
            let alpha = CGFloat(opacity / 100)
            let color = cell.btnColors[currentSegment].backgroundColor ?? UIColor.white
            cell.btnColors[currentSegment].backgroundColor = color.withAlphaComponent(alpha)
        }
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
}

extension ColorPickerVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100.widthRatio
        } else if indexPath.row == 1 {
            return 125.widthRatio
        } else {
            return 300.widthRatio
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PickerTableCell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath) as! PickerTableCell
        cell.parent = self
        cell.prepareCell(ind: indexPath.row)
        return cell
    }
}
