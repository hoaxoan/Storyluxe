//
//  GroupEditor.swift
//  OmniSense
//
//  Created by Sergey Koval on 23.12.2019.
//  Copyright © 2019 AntEtc, Inc. All rights reserved.
//

import UIKit
import ColorSlider

class ColorPicker: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var colorSlider: ColorSlider? = nil
    var chosenColor = "#999999"
    
    var baseView: UIView? = nil
    
    // MARK: - Init
    
    init(frame: CGRect, base: UIView?) {
        self.baseView = base
        super.init(frame: frame)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("ColorPicker", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 2, height: 2)
        
        colorButton.setTitle("", for: .normal)
        colorButton.alpha = 1
        
        actionButton = styleButton(actionButton, enabled: true, color: pinkTint, filled: true)
        actionButton.setTitle(NSLocalizedString("Choose color", comment: ""), for: .normal)
        cancelButton = styleButton(cancelButton, enabled: true, color: pinkTint)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        
        setColor()
        
        if colorSlider == nil {
            colorSlider = ColorSlider(orientation: .horizontal, previewSide: .bottom)
            colorSlider?.color = UIColor(hex: chosenColor)
            colorSlider?.frame = CGRect(x: colorButton.frame.origin.x, y: colorButton.frame.origin.y, width: colorButton.frame.width, height: 30)
            colorSlider?.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
            colorSlider?.alpha = 1
            contentView.addSubview(colorSlider!)
            colorSlider?.previewView?.transition(to: .inactive)
            colorSlider?.layoutSubviews()
        }
    }
    
    // MARK: - UI
    
    func styleButton(_ button: UIButton, enabled: Bool, color: UIColor, filled: Bool = false) -> UIButton {
        button.layer.borderColor = filled ? UIColor.clear.cgColor : color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.isEnabled = enabled
        button.layer.backgroundColor = (!filled ? .clear : color).cgColor
        button.setTitleColor((filled ? .white : color), for: .normal)
        return button
    }
    
    func setColor() {
        colorView.backgroundColor = .gray
        colorView.layer.cornerRadius = colorView.frame.width / 2
        colorView.layer.masksToBounds = true
    }

    // MARK: - Actions
    
    @objc
    func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        colorView.backgroundColor = color
        chosenColor = color.hexString!
    }
    
    @IBAction func actionPressed() {
        print(#function)
        let dict = ["color": chosenColor as Any, "base": baseView as Any] as [String : Any]
        NotificationCenter.default.post(name: .closeColorPicker, object: dict)
    }
    
    @IBAction func closeView() {
        print(#function)
        let dict = ["base": baseView as Any] as [String : Any]
        NotificationCenter.default.post(name: .closeColorPicker, object: dict)
    }
    
    @IBAction func hideKeyboard() {
        print(#function)
        endEditing(true)
    }
}

extension ColorPicker: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
