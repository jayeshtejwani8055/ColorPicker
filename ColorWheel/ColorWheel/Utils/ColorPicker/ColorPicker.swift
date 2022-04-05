//
//  ColorPicker.swift
//  ColorWheel
//
//  Created by Jayesh Tejwani on 05/04/22.
//

import UIKit

public class ColorPicker: UIControl {
    
    private(set) lazy var colorSpace: HRColorSpace = { preconditionFailure() }()

    public var color: UIColor {
        get {
            return hsvColor.uiColor
        }
    }

    private let colorMap = ColorMapView()
    private let colorMapCursor = ColorMapCursor()

    private lazy var hsvColor: HSVColor = { preconditionFailure() }()

    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(colorMap)
        addSubview(colorMapCursor)

        let colorMapPan = UIPanGestureRecognizer(target: self, action: #selector(self.handleColorMapPan(pan:)))
        colorMapPan.delegate = self
        colorMap.addGestureRecognizer(colorMapPan)

        let colorMapTap = UITapGestureRecognizer(target: self, action: #selector(self.handleColorMapTap(tap:)))
        colorMapTap.delegate = self
        colorMap.addGestureRecognizer(colorMapTap)
        feedbackGenerator.prepare()
    }

    public func set(color: UIColor, colorSpace: HRColorSpace) {
        self.colorSpace = colorSpace
        colorMap.colorSpace = colorSpace
        hsvColor = HSVColor(color: color, colorSpace: colorSpace)
        if superview != nil {
            mapColorToView(initialize: true)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        colorMap.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        colorMap.backgroundColor = .clear
        mapColorToView(initialize: true)
    }

    private func mapColorToView(initialize: Bool = false) {
        colorMap.set(brightness: hsvColor.brightness)
        colorMapCursor.center =  colorMap.convert(colorMap.position(for: hsvColor.hueAndSaturation), to: self)
        colorMapCursor.set(hsvColor: hsvColor)
    }
    
    @objc
    func handleColorMapPan(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            colorMapCursor.startEditing()
        case .cancelled, .ended, .failed:
            colorMapCursor.endEditing()
        default:
            break
        }
        let selected = colorMap.color(at: pan.location(in: colorMap))
        hsvColor = selected.with(brightness: hsvColor.brightness)
        mapColorToView()
        feedbackIfNeeds()
        sendActionIfNeeds()
    }

    @objc
    func handleColorMapTap(tap: UITapGestureRecognizer) {
        let selectedColor = colorMap.color(at: tap.location(in: colorMap))
        hsvColor = selectedColor.with(brightness: hsvColor.brightness)
        mapColorToView()
        feedbackIfNeeds()
        sendActionIfNeeds()
    }

    private var prevFeedbackedHSV: HSVColor?
    fileprivate func feedbackIfNeeds() {
        if prevFeedbackedHSV != hsvColor {
            feedbackGenerator.selectionChanged()
            prevFeedbackedHSV = hsvColor
        }
    }

    private var prevSentActionHSV: HSVColor?
    func sendActionIfNeeds() {
        if prevSentActionHSV != hsvColor {
            sendActions(for: .valueChanged)
            prevSentActionHSV = hsvColor
        }
    }
}

extension ColorPicker: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == colorMap, otherGestureRecognizer.view == colorMap {
            return true
        }
        return false
    }
}
