//
//  EditorViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 30.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    var isModernAspect = true
    var aspect = UIButton()
    var aspectCenter: CGPoint = .zero
    
    // sizes
    let size = CGSize(width: 35, height: 35)
    let top: CGFloat = 50
    let left: CGFloat = 25
    let scrollHeight: CGFloat = 40
    
    // button containers
    lazy var initialButtons: UIView = {
        let buttonsView = UIView(frame: view.frame)
        buttonsView.backgroundColor = .clear
        buttonsView.isHidden = false
        return buttonsView
    }()
    
    lazy var textEditButtons: UIView = {
        let buttonsView = UIView(frame: view.frame)
        buttonsView.backgroundColor = .clear
        buttonsView.isHidden = true
        return buttonsView
    }()
    
    // collage parts
    var container = UIView()
    var template = UIImageView()
    let backdrop = UIImageView()
    
    // gesture regognizers for container views
    lazy var hideScrollviewRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(backdropHide))
        return gesture
    }()
    
    lazy var endEditRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(endEditing))
        return gesture
    }()
    
    lazy var selectScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = blackTint
        scrollView.frame = CGRect(x: 0, y: view.bounds.height, width: view.frame.width, height: 3*scrollHeight)
        var offset: CGFloat = left
        let backdrops = Global.shared.backdrops().flatMap{$0.set}
        backdrops.enumerated().forEach { index, backdrop in
            let width = 70
            let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width)))
            button.backgroundColor = .lightGray
            button.frame.origin.x = offset
            button.frame.origin.y += 7
            offset = button.frame.maxX + left
            button.setTitle("", for: .normal)
            if index == 0 {
                button.setImage(UIImage(named: backdrop.filename)?.resize(CGFloat(width/2)), for: .normal)
            }
            else {
                button.setBackgroundImage(UIImage(named: backdrop.filename), for: .normal)
            }
            button.tag = index
            button.layer.cornerRadius = 7
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.borderWidth = 2
//            button.layer.addShadow()
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(backdropSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
            
            if backdrop.isPremium {
                let lock = Global.shared.lock(25)
                lock.center = CGPoint(x: button.frame.maxX - 7, y: button.frame.minY + 7)
                scrollView.addSubview(lock)
            }
        }
        scrollView.contentSize = CGSize(width: offset, height: scrollHeight)
        return scrollView
    }()
    
    var collage: Collage? {
        didSet {
            updateCollage()
        }
    }
    
    // texts
    var texts = [Text]()
    
    lazy var fontSlider: UISlider = {
        let width: CGFloat = 200
        let slider = UISlider(frame: CGRect(x: -80, y: view.center.y - width/2 + 40, width: width, height: 10))
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.tintColor = pinkTint
        slider.addTarget(self, action: #selector(updateFontSize(_:)), for: .valueChanged)
        return slider
    }()
    
    var colorButton = UIButton()
    var colorPicker: UIView? = nil
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(closeColorPicker), name: .closeColorPicker, object: nil)
        
        view.tintColor = pinkTint
        view.backgroundColor = blackTint
        setupInitialButtons()
        setupTextEditButtons()
        container.addGestureRecognizer(hideScrollviewRecognizer)
        view.addSubview(selectScrollView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
    }
    
    // MARK: - UI
    
    // MARK: Initial buttons
    
    func setupInitialButtons() {

        // more
        let more = Global.shared.button("more-vertical", CGRect(origin: CGPoint(x: 20, y: top), size: size), lightGrayTint, .small)
        more.addTarget(self, action: #selector(menu), for: .touchUpInside)
        initialButtons.addSubview(more)
        
        // aspect
        aspect.frame = CGRect(origin: CGPoint(x: 1.5*left + size.width, y: top), size: CGSize(width: 25, height: size.height))
        aspect.setTitle("9:16", for: .normal)
        aspect.titleLabel?.font = .systemFont(ofSize: 6)
        aspect.titleLabel?.textAlignment = .center
        aspect.setTitleColor(lightGrayTint, for: .normal)
        aspect.layer.cornerRadius = 3
        aspect.layer.borderColor = lightGrayTint.cgColor
        aspect.layer.borderWidth = 1
        aspect.addTarget(self, action: #selector(aspectUpdate), for: .touchUpInside)
        initialButtons.addSubview(aspect)
        aspectCenter = aspect.center
        
        // text
        let newText = Global.shared.button("text", CGRect(origin: CGPoint(x: (view.frame.width - 35)/2, y: top), size: size), lightGrayTint)
        newText.addTarget(self, action: #selector(newTextTapped), for: .touchUpInside)
        initialButtons.addSubview(newText)
        
        // close
        let dismiss = Global.shared.button("close-white", CGRect(origin: CGPoint(x: view.frame.width - 50, y: top), size: size), lightGrayTint, .verysmall)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        initialButtons.addSubview(dismiss)
        
        // bottom buttons
        
        let offset = view.frame.width/5
        var centers = [CGFloat]()
        for i in 0...4 {
            centers.append(CGFloat(i + 1)*offset - 1.5*left)
        }
        
        let (button1, border) = Global.shared.tabButton("borders", "Borders", view, centers[0], .white, true)
        button1.addTarget(self, action: #selector(borders), for: .touchUpInside)
        initialButtons.addSubview(border)
        
        let (button2, brand) = Global.shared.tabButton("icon-trans", "Branding", view, centers[1], nil, true)
        button2.addTarget(self, action: #selector(branding), for: .touchUpInside)
        initialButtons.addSubview(brand)

        let (button3, templates) = Global.shared.tabButton("templates", "Templates", view, centers[2], .white, true)
        button3.addTarget(self, action: #selector(templateTapped), for: .touchUpInside)
        initialButtons.addSubview(templates)

        let (button4, camera) = Global.shared.tabButton("backdrop", "Backdrop", view, centers[3], nil, true)
        button4.addTarget(self, action: #selector(backdropShow), for: .touchUpInside)
        initialButtons.addSubview(camera)
        
        let (button5, save) = Global.shared.tabButton("export", "Export", view, centers[4], .white, true)
        button5.addTarget(self, action: #selector(exportTapped), for: .touchUpInside)
        initialButtons.addSubview(save)
        
        view.addSubview(initialButtons)
        
        setupCollage()
    }
    
    func setupCollage() {
        
        // container that holds everything
        container.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width - 2*left, height: 0.75*view.frame.height))
        container.layer.cornerRadius = 20
        container.backgroundColor = .darkGray
        container.layer.masksToBounds = true
        container.isUserInteractionEnabled = true
        view.addSubview(container)
        container.center = view.center
        
        // backdrop
        backdrop.frame = CGRect(origin: .zero, size: container.frame.size)
        backdrop.contentMode = .scaleAspectFill
        container.addSubview(backdrop)
        
        // frame
        template.contentMode = .scaleAspectFill
        template.frame = backdrop.frame
        backdrop.addSubview(template)
        
        updateCollage()
    }
    
    func updateCollage() {
        template.image = collage?.kit.template.getImage()
        backdrop.image = collage?.kit.backdrop?.getImage()
        if let texts = collage?.kit.texts {
            self.texts = texts
        }
        layoutTexts()
    }
    
    // MARK: Text Edit buttons
    
    func setupTextEditButtons() {
        // top buttons
        
        // more
        let more = Global.shared.button("trash", CGRect(origin: CGPoint(x: 20, y: top), size: size), lightGrayTint, .normal)
        more.addTarget(self, action: #selector(deleteText), for: .touchUpInside)
        textEditButtons.addSubview(more)
        
        // text
        let newText = Global.shared.button("text", CGRect(origin: CGPoint(x: (view.frame.width - 35)/2, y: top), size: size), lightGrayTint)
        newText.addTarget(self, action: #selector(newTextTapped), for: .touchUpInside)
        textEditButtons.addSubview(newText)
        
        // close
        let dismiss = UIButton(frame: CGRect(origin: CGPoint(x: view.frame.width - 20 - 2*size.width, y: top), size: CGSize(width: 2*size.width, height: size.height)))
        dismiss.setTitle("Done", for: .normal)
        dismiss.addTarget(self, action: #selector(returnToInitialState), for: .touchUpInside)
        textEditButtons.addSubview(dismiss)
        
        // bottom buttons
        
        let offset = view.frame.width/3
        var centers = [CGFloat]()
        for i in 0...2 {
            centers.append(CGFloat(i + 1)*offset - 2.5*left)
        }
        
        let (button1, border) = Global.shared.tabButton("circle", "Color", view, centers[0], getFieldColor(), true)
        colorButton = button1
        colorButton.addTarget(self, action: #selector(colorTapped), for: .touchUpInside)
        textEditButtons.addSubview(border)
        
        let (button2, brand) = Global.shared.tabButton("icon-trans", "Font", view, centers[1], nil, true)
        button2.addTarget(self, action: #selector(fontTapped), for: .touchUpInside)
        textEditButtons.addSubview(brand)

        let (button3, templates) = Global.shared.tabButton("pencil", "Edit", view, centers[2], .white, true)
        button3.addTarget(self, action: #selector(editField), for: .touchUpInside)
        textEditButtons.addSubview(templates)
        
        textEditButtons.addGestureRecognizer(endEditRecognizer)
        
        view.addSubview(textEditButtons)
    }
    
    @objc func returnToInitialState() {
        toggleInterface(false)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
        view.subviews.forEach{ if $0 is UITextField {$0.layer.borderWidth = 0} }
        toggleInterface(false)
    }
    
    func toggleInterface(_ isEditing: Bool) {
        initialButtons.isHidden = isEditing
        textEditButtons.isHidden = !isEditing
        
        if !isEditing {
            view.endEditing(true)
            collage?.kit.texts = texts.filter{ !$0.text.isEmpty }
            layoutTexts()
        }
    }
    
    // MARK: - Initial button actions
    
    // top buttons
    
    @objc func menu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            //
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.view.tintColor = pinkTint
        present(alert, animated: true, completion: nil)
    }
    
    @objc func aspectUpdate() {
        isModernAspect = !isModernAspect
        aspect.setTitle(isModernAspect ? "9:16" : "4:5", for: .normal)
        aspect.frame = CGRect(origin: CGPoint(x: 1.5*left + size.width, y: top), size: CGSize(width: 25, height: isModernAspect ? size.height : size.height*0.85))
        aspect.center = aspectCenter
        
        container.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width - (2 * left), height: (isModernAspect ? 0.75 : 0.6)*view.frame.height))
        container.center = view.center
        
        let offset = (0.15*view.frame.height)/2
        backdrop.frame.origin.y = isModernAspect ? 0 : -offset
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // bottom buttons
    
    @objc func borders() {
        
    }
    
    @objc func branding() {
        
    }
    
    @objc func templateTapped() {
        let templatesVC = TemplatesViewController()
        templatesVC.modalPresentationStyle = .fullScreen
        present(templatesVC, animated: true, completion: nil)
    }
    
    @objc func exportTapped() {
        let exportImage = container.takeScreenshot()
        UIImageWriteToSavedPhotosAlbum(exportImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }

    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // MARK: - Text editing
    
    // add new text field
    @objc func newTextTapped() {
        var text = Text(text: "",
                        color: Color(hex: "#FFFFFFFF"),
                        font: Font(name: "BodoniSvtyTwoOSITCTT-Book", size: 35),
                        alignment: Alignment(state: .center),
                        location: Location(x: 0, y: view.frame.height/2))
        text.center = view.center
        texts.append(text)
        
        let field = textField(text)
        view.addSubview(field)
        field.becomeFirstResponder()
    }
    
    // get current active field
    func activeField() -> UITextField? {
        return view.subviews.first(where: {$0 is UITextField && $0.isFirstResponder}) as? UITextField
    }
    
    // construct a field
    func textField(_ text: Text) -> UITextField {
        let textField = UITextField(frame: CGRect(origin: text.location.point(), size: CGSize(width: view.frame.width, height: text.height)))
        textField.text = text.text
        textField.textAlignment = text.alignment.align()
        textField.font = text.font.font()
        textField.textColor = text.color.color()
        textField.delegate = self
        textField.tag = texts.count - 1
        textField.center = text.center
        return textField
    }
    
    func layoutTexts() {
        view.subviews.forEach{ if $0 is UITextField {$0.removeFromSuperview()} }
        for (index, text) in texts.filter({ !$0.text.isEmpty }).enumerated() {
            let field = textField(text)
            field.sizeToFit()
            field.frame.size.width += 20
            field.layer.borderColor = UIColor.black.cgColor
            field.layer.borderWidth = 0
            field.center = text.center
            field.tag = index
            field.isUserInteractionEnabled = true
            field.addGestureRecognizer(panRecognizer())
            field.addGestureRecognizer(tapRecognizer())
            view.addSubview(field)
        }
    }
    
    // MARK: Tap recognizer
    
    func tapRecognizer() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(selectTextField(_:)))
        return gesture
    }
    
    @objc func selectTextField(_ sender: UITapGestureRecognizer) {
        if let field = sender.view as? UITextField {
            if field.layer.borderWidth > 0.0 {
                field.becomeFirstResponder()
            }
            else {
                view.subviews.forEach{ if $0 is UITextField {$0.layer.borderWidth = 0} }
                view.bringSubviewToFront(field)
                field.layer.borderColor = UIColor.black.cgColor
                field.layer.borderWidth = 1
                colorButton.setImage(UIImage(named: "circle")?.tint(color: getFieldColor()).resize(30), for: .normal)
            }
            initialButtons.isHidden = true
            textEditButtons.isHidden = false
        }
    }
    
    // MARK: Pan recognizer
    
    func panRecognizer() -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(draggedView(_:)))
        return gesture
    }
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        if let field = sender.view as? UITextField {
            view.bringSubviewToFront(field)
            let translation = sender.translation(in: self.view)
            field.center = CGPoint(x: field.center.x + translation.x, y: field.center.y + translation.y)
            sender.setTranslation(.zero, in: self.view)
            
            if field.tag < texts.count {
                var text = texts[field.tag]
                text.center = field.center
                texts[field.tag] = text
            }
        }
    }
    
    // MARK: Color picker
    
    @objc func colorTapped() {
        if colorPicker == nil {
            colorPicker = UIView(frame: view.frame)
            colorPicker?.layer.backgroundColor = UIColor(white: 0, alpha: 0.5).cgColor
            if let info = ColorManager.shared.colorPicker() {
                info.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeColorPicker)))
                colorPicker?.addSubview(info)
                UIApplication.shared.keyWindow?.addSubview(colorPicker!)
                UIView.animate(withDuration: 0.5) { info.alpha = 1 }
            }
        }
    }
    
    @objc func closeColorPicker(_ notification: Notification?) {
        if colorPicker != nil {
    
            if let object = notification?.object as? [String: Any], let color = object["color"] as? String {
                print(#function, color)
                if let field = view.subviews.first(where: {$0.layer.borderWidth > 0}) as? UITextField {
                    var text = texts[field.tag]
                    text.color = Color(hex: color)
                    texts[field.tag] = text
                    field.textColor = UIColor(hex: color)
                    collage?.kit.texts = texts.filter{ !$0.text.isEmpty }
                    toggleInterface(false)
                }
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.colorPicker?.alpha = 0
            }) { _ in
                self.colorPicker?.removeFromSuperview()
                self.colorPicker = nil
            }
        }
    }
    
    func getFieldColor() -> UIColor {
        var color = UIColor.gray
        if let field = view.subviews.first(where: {$0.layer.borderWidth > 0}) as? UITextField {
            let text = texts[field.tag]
            color = text.color.color()
        }
        return color
    }
    
    // MARK: Font picker
    
    @objc func fontTapped() {
        
    }
    
    // MARK: Other
    
    @objc func deleteText() {
        if let field = view.subviews.first(where: {$0.layer.borderWidth > 0}) as? UITextField, field.tag < texts.count {
            texts.remove(at: field.tag)
            toggleInterface(false)
        }
    }
    
    @objc func editField() {
        if let field = view.subviews.first(where: {$0.layer.borderWidth > 0}) as? UITextField {
            field.becomeFirstResponder()
        }
    }
    
    // MARK: - Slider action
    
    @objc func updateFontSize(_ sender: UISlider) {
        
        if let field = activeField(), let font = field.font {
            field.font = UIFont(name: font.fontName, size: CGFloat(sender.value))
            
            if field.tag < texts.count {
                var text = texts[field.tag]
                let font = text.font.font()
                text.font = Font(name: font.fontName, size: CGFloat(sender.value))
                self.texts[field.tag] = text
            }
        }
    }
    
    // MARK: - Backdrop
    
    @objc func backdropShow() {
        guard selectScrollView.frame.origin.y == view.bounds.height else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.selectScrollView.frame.origin.y = self.view.bounds.height - 3*self.scrollHeight
            self.view.setNeedsLayout()
        }) { _ in
            self.toggleInterface(false)
        }
    }
    
    @objc func backdropHide() {
        guard selectScrollView.frame.origin.y < view.bounds.height else { return }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.selectScrollView.frame.origin.y = self.view.bounds.height
            self.view.setNeedsLayout()
        }) { _ in
            self.toggleInterface(false)
        }
    }
    
    @objc func backdropSelected(_ sender: UIButton) {
        let index = sender.tag
        let set = Global.shared.backdrops().flatMap({$0.set})[index]
        if set.isPremium {
            let purchaseVC = PurchaseViewController()
            present(purchaseVC, animated: true, completion: nil)
        }
        else {
            if let image = UIImage(named: set.filename) {
                collage?.kit.backdrop = Image(withImage: image)
                updateCollage()
            }
        }
    }
}

// MARK: - Extensions & Delegates

extension EditorViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        toggleInterface(true)
        if let size = textField.font?.pointSize {
            fontSlider.value = Float(size)
        }
        view.addSubview(fontSlider)
        fontSlider.rotate(degrees: 90)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let string = textField.text, textField.tag < texts.count {
            var text = texts[textField.tag]
            text.text = string
            texts[textField.tag] = text
        }
        fontSlider.removeFromSuperview()
        toggleInterface(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let string = textField.text, textField.tag < texts.count {
            var text = texts[textField.tag]
            text.text = string
            texts[textField.tag] = text
        }
        toggleInterface(false)
        return true
    }
}
