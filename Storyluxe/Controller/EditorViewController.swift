//
//  EditorViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 30.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit
import ColorSlider

class EditorViewController: UIViewController {
    
    private var isModernAspect = true
    private var aspect = UIButton()
    private var aspectCenter: CGPoint = .zero
    
    // sizes
    private let size = CGSize(width: 35, height: 35)
    private let top: CGFloat = 50
    private let left: CGFloat = 25
    private let scrollHeight: CGFloat = 40
    
    // button containers
    private lazy var initialButtonsView: PassthroughView = {
        let buttonsView = PassthroughView(frame: view.frame)
        buttonsView.backgroundColor = .clear
        buttonsView.isHidden = false
        return buttonsView
    }()
    
    private lazy var textEditButtonsView: PassthroughView = {
        let buttonsView = PassthroughView(frame: view.frame)
        buttonsView.backgroundColor = .clear
        buttonsView.isHidden = true
        return buttonsView
    }()
    
    // collage parts
    private var containerView = UIView()
    private var templateImageView = UIImageView()
    private let backdropImageView = UIImageView()
    
    // gesture regognizers for container views
    private lazy var hideScrollviewRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(hideEditors))
        return gesture
    }()
    
    private lazy var endEditRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(endEditing))
        return gesture
    }()
    
    private lazy var selectScrollView: UIScrollView = {
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
            if viewIfLoaded?.window != nil {
                let thumbnail = containerView.takeScreenshot()
                collage?.kit.thumbnail = Image(withImage: thumbnail)
                updateCollage()
            }
        }
    }
    
    // texts
    private var texts = [Text]()
    
    private lazy var fontSlider: UISlider = {
        let width: CGFloat = 200
        let slider = UISlider(frame: CGRect(x: -80, y: view.center.y - width/2 + 40, width: width, height: 10))
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.tintColor = pinkTint
        slider.addTarget(self, action: #selector(updateFontSize(_:)), for: .valueChanged)
        return slider
    }()
    
    private var colorButton = UIButton()
    private var colorPicker: UIView? = nil
    
    private lazy var imagePicker = ImagePicker()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeColorPicker), name: .closeColorPicker, object: nil)
        
        imagePicker.delegate = self
        
        view.tintColor = pinkTint
        view.backgroundColor = blackTint
        
        isModernAspect = collage?.kit.aspect == Aspect.aspect9_16
        
        setupInitialButtons()
        setupTextEditButtons()
        containerView.addGestureRecognizer(hideScrollviewRecognizer)
        view.addSubview(selectScrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
    }
    
    // MARK: - UI
    
    // MARK: Initial buttons
    
    func button(_ size: CGSize, _ center: CGPoint, _ index: Int) -> UIButton {
        let button = UIButton(frame: CGRect(origin: .zero, size: size))
        button.tag = index
        button.backgroundColor = .lightGray
        button.setImage(UIImage(named: "plus-large")?.tint(color: .white), for: .normal)
        button.center = center
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        if let images = collage?.kit.images, button.tag < images.count, let image = collage?.kit.images?[button.tag] {
            button.setImage(image.getImage(), for: .normal)
        }
        return button
    }
    
    func setupInitialButtons() {
        
        // more
        let more = Global.shared.button("more-vertical", CGRect(origin: CGPoint(x: 20, y: top), size: size), lightGrayTint, .small)
        more.addTarget(self, action: #selector(menu), for: .touchUpInside)
        initialButtonsView.addSubview(more)
        
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
        initialButtonsView.addSubview(aspect)
        aspectCenter = aspect.center
        
        // text
        let newText = Global.shared.button("text", CGRect(origin: CGPoint(x: (view.frame.width - 35)/2, y: top), size: size), lightGrayTint)
        newText.addTarget(self, action: #selector(newTextTapped), for: .touchUpInside)
        initialButtonsView.addSubview(newText)
        
        // close
        let dismiss = Global.shared.button("close-white", CGRect(origin: CGPoint(x: view.frame.width - 50, y: top), size: size), lightGrayTint, .verysmall)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        initialButtonsView.addSubview(dismiss)
        
        // bottom buttons
        
        let offset = view.frame.width/5
        var centers = [CGFloat]()
        for i in 0...4 {
            centers.append(CGFloat(i + 1)*offset - 1.5*left)
        }
        
        let (button1, border) = Global.shared.tabButton("borders", "Borders", view, centers[0], .white, true)
        button1.addTarget(self, action: #selector(bordersTapped), for: .touchUpInside)
        if let collage = collage {
            button1.isEnabled = collage.kit.canChangeBorder
        }
        initialButtonsView.addSubview(border)
        
        let (button2, brand) = Global.shared.tabButton("icon-trans", "Branding", view, centers[1], nil, true)
        button2.addTarget(self, action: #selector(brandingTapped), for: .touchUpInside)
        button2.isEnabled = false
        initialButtonsView.addSubview(brand)
        
        let (button3, templates) = Global.shared.tabButton("templates", "Templates", view, centers[2], .white, true)
        button3.addTarget(self, action: #selector(templateTapped), for: .touchUpInside)
        initialButtonsView.addSubview(templates)
        
        let (button4, camera) = Global.shared.tabButton("backdrop", "Backdrop", view, centers[3], nil, true)
        button4.addTarget(self, action: #selector(backdropShow), for: .touchUpInside)
        initialButtonsView.addSubview(camera)
        
        let (button5, save) = Global.shared.tabButton("export", "Export", view, centers[4], .white, true)
        button5.addTarget(self, action: #selector(exportTapped), for: .touchUpInside)
        initialButtonsView.addSubview(save)
        
        view.addSubview(initialButtonsView)
        
        setupCollage()
    }
    
    // MARK: - COLLAGE
    
    func setupCollage() {
        containerView.subviews.forEach{$0.removeFromSuperview()}
        
        // container that holds everything
//        containerView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width - 2*left, height: 0.75*view.frame.height))
        
        containerView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width - (2 * left), height: (isModernAspect ? 0.75 : 0.6)*view.frame.height))
        containerView.center = view.center
        
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = .darkGray
        containerView.layer.masksToBounds = true
        containerView.isUserInteractionEnabled = true
        view.addSubview(containerView)
        containerView.center = view.center
        
        // backdrop
        backdropImageView.frame = CGRect(origin: .zero, size: containerView.frame.size)
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.isUserInteractionEnabled = true
        containerView.addSubview(backdropImageView)
        
        // frame
        templateImageView.contentMode = .scaleAspectFill
        templateImageView.frame = backdropImageView.frame
        templateImageView.isUserInteractionEnabled = false
        containerView.addSubview(templateImageView)

        setupPlaceholders()
        updateCollage()
    }
    
    func setupPlaceholders() {
        backdropImageView.subviews.forEach{$0.removeFromSuperview()}
        var imageCenter = backdropImageView.center
        switch collage?.kit.type {
        case .one:
            imageCenter.y -= 25
            let button1 = button(CGSize(width: view.frame.width * 0.66, height: view.frame.height * 0.41), imageCenter, 0)
            button1.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            backdropImageView.addSubview(button1)
        case .two:
            let width: CGFloat = view.frame.width * 0.50
            let height: CGFloat = view.frame.height * 0.32
            
            imageCenter.y -= 90
            imageCenter.x -= 91
            let button1 = button(CGSize(width: width, height: height), imageCenter, 0)
            button1.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            button1.rotate(degrees: -2.5)
            backdropImageView.addSubview(button1)
            
            imageCenter = backdropImageView.center
            imageCenter.y += 50
            imageCenter.x += 92
            let button2 = button(CGSize(width: width, height: height), imageCenter, 1)
            button2.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            button2.rotate(degrees: 2.5)
            backdropImageView.addSubview(button2)
        case .three:
            let width: CGFloat = view.frame.width * 0.91
            let height: CGFloat = view.frame.height * 0.235
            
            imageCenter.y -= 155
            let button1 = button(CGSize(width: width, height: height), imageCenter, 0)
            button1.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            button1.rotate(degrees: 5.8)
            backdropImageView.addSubview(button1)
            
            imageCenter = backdropImageView.center
            imageCenter.y += 82
            let button2 = button(CGSize(width: width, height: height), imageCenter, 1)
            button2.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            button2.rotate(degrees: -1.6)
            backdropImageView.addSubview(button2)

            imageCenter = backdropImageView.center
            imageCenter.y += 330
            let button3 = button(CGSize(width: width, height: height), imageCenter, 2)
            button3.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            button3.rotate(degrees: -3.5)
            backdropImageView.addSubview(button3)
        case .four:
            let width: CGFloat = view.frame.width * 0.5
            let height: CGFloat = view.frame.height * 0.325
            
            // right side
            imageCenter = backdropImageView.center
            imageCenter.y -= 161
            imageCenter.x += 85

            let button2 = button(CGSize(width: width, height: height), imageCenter, 1)
            button2.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            button2.rotate(degrees: -1.3)
            backdropImageView.addSubview(button2)

            imageCenter = backdropImageView.center
            imageCenter.y += 135
            imageCenter.x += 103
            let button4 = button(CGSize(width: width, height: height), imageCenter, 3)
            button4.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            button4.rotate(degrees: -1.2)
            backdropImageView.addSubview(button4)
            
            // left side
            imageCenter = backdropImageView.center
            imageCenter.y -= 136
            imageCenter.x -= 103
            let button1 = button(CGSize(width: width, height: height), imageCenter, 0)
            button1.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            button1.rotate(degrees: -1.2)
            backdropImageView.addSubview(button1)

            imageCenter = backdropImageView.center
            imageCenter.y += 162
            imageCenter.x -= 106
            let button3 = button(CGSize(width: width, height: height), imageCenter, 2)
            button3.addTarget(self, action: #selector(frameSelected(_:)), for: .touchUpInside)
            button3.rotate(degrees: -1.0)
            backdropImageView.addSubview(button3)
        default: break }
    }
    
    func updateCollage() {
        print(#function)
        if let color = collage?.kit.border?.color() {
            templateImageView.image = collage?.kit.template.getImage()?.tint(color: color, .multiply)
        }
        else {
            templateImageView.image = collage?.kit.template.getImage()
        }
        
        backdropImageView.image = collage?.kit.backdrop?.getImage()
        
        if let texts = collage?.kit.texts {
            self.texts = texts
        }
        layoutTexts()
        saveCollage()
    }
    
    func saveCollage() {
        
        
        if var collages = Global.shared.restore(userCollagesKey) as [Collage]?, collages.count > 0 {
            if let index = collages.firstIndex(where: {$0.id == self.collage?.id}) {
                collages[index] = self.collage!
            }
            else {
                collages.append(self.collage!)
            }
            Global.shared.save(collages, key: userCollagesKey)
        }
        else {
            Global.shared.save([self.collage], key: userCollagesKey)
        }
    }
    
    // MARK: - Text Edit buttons
    
    func setupTextEditButtons() {
        // top buttons
        
        // more
        let more = Global.shared.button("trash", CGRect(origin: CGPoint(x: 20, y: top), size: size), lightGrayTint, .normal)
        more.addTarget(self, action: #selector(deleteText), for: .touchUpInside)
        textEditButtonsView.addSubview(more)
        
        // text
        let newText = Global.shared.button("text", CGRect(origin: CGPoint(x: (view.frame.width - 35)/2, y: top), size: size), lightGrayTint)
        newText.addTarget(self, action: #selector(newTextTapped), for: .touchUpInside)
        textEditButtonsView.addSubview(newText)
        
        // close
        let dismiss = UIButton(frame: CGRect(origin: CGPoint(x: view.frame.width - 20 - 2*size.width, y: top), size: CGSize(width: 2*size.width, height: size.height)))
        dismiss.setTitle("Done", for: .normal)
        dismiss.addTarget(self, action: #selector(returnToInitialState), for: .touchUpInside)
        textEditButtonsView.addSubview(dismiss)
        
        // bottom buttons
        
        let offset = view.frame.width/3
        var centers = [CGFloat]()
        for i in 0...2 {
            centers.append(CGFloat(i + 1)*offset - 2.5*left)
        }
        
        let (button1, border) = Global.shared.tabButton("circle", "Color", view, centers[0], getFieldColor(), true)
        colorButton = button1
        colorButton.addTarget(self, action: #selector(colorTapped), for: .touchUpInside)
        textEditButtonsView.addSubview(border)
        
        let (button2, brand) = Global.shared.tabButton("icon-trans", "Font", view, centers[1], nil, true)
        button2.addTarget(self, action: #selector(fontTapped), for: .touchUpInside)
        textEditButtonsView.addSubview(brand)
        
        let (button3, templates) = Global.shared.tabButton("pencil", "Edit", view, centers[2], .white, true)
        button3.addTarget(self, action: #selector(editField), for: .touchUpInside)
        textEditButtonsView.addSubview(templates)
        
        textEditButtonsView.addGestureRecognizer(endEditRecognizer)
        
        view.addSubview(textEditButtonsView)
    }
    
    @objc func returnToInitialState() {
        toggleInterface(false)
    }
    
    @objc func endEditing() {
        containerView.subviews.forEach{ if $0 is UITextField {$0.layer.borderWidth = 0} }
        toggleInterface(false)
    }
    
    func toggleInterface(_ isEditing: Bool) {
        initialButtonsView.isHidden = isEditing
        textEditButtonsView.isHidden = !isEditing
        
        if !isEditing {
            view.endEditing(true)
            collage?.kit.texts = texts.filter{ !$0.text.isEmpty }
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
        collage?.kit.aspect = isModernAspect ? .aspect9_16 : .aspect4_5
        aspect.setTitle(isModernAspect ? "9:16" : "4:5", for: .normal)
        aspect.frame = CGRect(origin: CGPoint(x: 1.5*left + size.width, y: top), size: CGSize(width: 25, height: isModernAspect ? size.height : size.height*0.85))
        aspect.center = aspectCenter
        
        setupCollage()
    }
    
    @objc func close() {
        collage?.kit.texts = texts
        dismiss(animated: true, completion: nil)
    }
    
    // bottom buttons
    
    @objc func brandingTapped() {
        
    }
    
    @objc func exportTapped() {
        let exportImage = containerView.takeScreenshot()
        UIImageWriteToSavedPhotosAlbum(exportImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // MARK: - Template handling
    
    @objc func templateTapped() {
        let templatesVC = TemplatesViewController()
        templatesVC.modalPresentationStyle = .fullScreen
        present(templatesVC, animated: true, completion: nil)
    }
    
    var selectedImageIndex: Int = 0
    
    @objc func frameSelected(_ sender: UIButton) {
        selectedImageIndex = sender.tag
        hideEditors()
        selectImageSource()
    }
    
    func selectImageSource() {
        let alert = UIAlertController(title: "Select source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo gallery", style: .default, handler: { _ in
            self.imagePicker.photoGalleryAsscessRequest()
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.imagePicker.cameraAsscessRequest()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.imagePicker.present(parent: self, sourceType: sourceType)
        }
    }
    
    // MARK: - Add image to Library
    
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
                        location: Location(x: 0, y: containerView.frame.height/2))
        text.center = containerView.center
        texts.append(text)
        
        let field = textField(text)
        containerView.addSubview(field)
        field.becomeFirstResponder()
    }
    
    // get current active field
    func activeField() -> UITextField? {
        return containerView.subviews.first(where: {$0 is UITextField && $0.isFirstResponder}) as? UITextField
    }
    
    // get selected field (with black frame)
    func selectedField() -> UITextField? {
        if let field = containerView.subviews.first(where: {$0.layer.borderWidth > 0}) as? UITextField, field.tag < texts.count {
            return field
        }
        return nil
    }
    
    // construct a field
    func textField(_ text: Text) -> UITextField {
        let textField = UITextField(frame: CGRect(origin: text.location.point(), size: CGSize(width: containerView.frame.width, height: text.height)))
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
        containerView.subviews.forEach{ if $0 is UITextField {$0.removeFromSuperview()} }
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
            containerView.addSubview(field)
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
                containerView.subviews.forEach{ if $0 is UITextField {$0.layer.borderWidth = 0} }
                containerView.bringSubviewToFront(field)
                field.layer.borderColor = UIColor.black.cgColor
                field.layer.borderWidth = 1
                colorButton.setImage(UIImage(named: "circle")?.tint(color: getFieldColor()).resize(30), for: .normal)
            }
            initialButtonsView.isHidden = true
            textEditButtonsView.isHidden = false
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
            containerView.bringSubviewToFront(field)
            let translation = sender.translation(in: self.containerView)
            field.center = CGPoint(x: field.center.x + translation.x, y: field.center.y + translation.y)
            sender.setTranslation(.zero, in: self.view)
            
            if field.tag < texts.count {
                var text = texts[field.tag]
                text.center = field.center
                texts[field.tag] = text
            }
        }
    }
    
    // MARK: Other
    
    @objc func deleteText() {
        if let field = selectedField() {
            texts.remove(at: field.tag)
            toggleInterface(false)
        }
    }
    
    @objc func editField() {
        if let field = selectedField() {
            field.becomeFirstResponder()
        }
    }
    
    // MARK: - Color picker
    
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
                if let field = selectedField() {
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
        if let field = selectedField() {
            let text = texts[field.tag]
            color = text.color.color()
        }
        return color
    }
    
    // MARK: - Font picker
    
    // Views
    let tableCellIdentifier = "TableCell"
    var fontNames = [[String: String]]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height))
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.isHidden = true
        return tableView
    }()
    
    @objc func fontTapped() {
        fontNames.removeAll()
        for family in UIFont.familyNames {
            let sName: String = family as String
            for name in UIFont.fontNames(forFamilyName: sName) {
                if !name.hasSuffix("Bold") &&
                    !name.hasSuffix("Italic") &&
                    !name.hasSuffix("Black") &&
                    !name.hasSuffix("Light") &&
                    !name.hasSuffix("Medium") &&
                    !name.hasSuffix("Heavy") &&
                    !name.hasSuffix("Thin") &&
                    !name.hasSuffix("ItalicMT") &&
                    !name.hasSuffix("BoldMT") &&
                    !name.hasSuffix("Oblique") &&
                    !name.hasSuffix("Semibold") &&
                    !name.hasSuffix("Ultralight") &&
                    !name.hasSuffix("Condensed") &&
                    !name.hasSuffix("BookIt") {
                    fontNames.append(["family": sName, "name": name])
                    //                    print("family name: \(sName as String), name: \(name as String)")
                }
            }
        }
        fontNames = fontNames.sorted{ $0["family"]!.lowercased() < $1["family"]!.lowercased() }
        print("names: \(fontNames)")
        
        view.addSubview(tableView)
        tableView.isHidden = false
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
    
    @objc func hideEditors() {
        print(#function)
        
        endEditing()
        
        // color slider hide
        if colorSlider != nil {
            let container = colorSlider?.superview
            UIView.animate(withDuration: 0.3, animations: {
                container?.frame.origin.y = self.view.frame.height
            }) { _ in
                container?.removeFromSuperview()
                self.colorSlider = nil
            }
        }
        
        // backdrop picker hide
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
        if set.isPremium && !UserDefaults.standard.bool(forKey: isPurchaseUnlocked) {
            let purchaseVC = PurchaseViewController()
            present(purchaseVC, animated: true, completion: nil)
        }
        else {
            if let image = UIImage(named: set.filename) {
                backdropImageView.image = image
                collage?.kit.backdrop = Image(withImage: image)
            }
        }
    }
    
    // MARK: - Border color
    
    var colorSlider: ColorSlider? = nil
    
    @objc func bordersTapped() {
        if colorSlider == nil {
            let chosenColor = collage?.kit.border?.color()
            colorSlider = ColorSlider(orientation: .horizontal, previewSide: .bottom)
            colorSlider?.color = chosenColor ?? .clear
            colorSlider?.frame = CGRect(x: left, y: left, width: view.frame.width - 2*left, height: 30)
            colorSlider?.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
            colorSlider?.alpha = 1
            
            let height: CGFloat = 3*top
            let contentView = UIView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height))
            contentView.backgroundColor = blackTint
            contentView.addSubview(colorSlider!)
            view.addSubview(contentView)
            
            colorSlider?.previewView?.transition(to: .inactive)
            colorSlider?.layoutSubviews()
            
            UIView.animate(withDuration: 0.3, animations: {
                contentView.frame.origin.y -= height
            })
        }
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        if let hex = slider.color.hexString {
            collage?.kit.border = Color(hex: hex)
        }
    }
}

// MARK: - UITextFieldDelegate

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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension EditorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fontNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath)
        cell.backgroundColor = .black
        let fontName = fontNames[indexPath.row]
        cell.textLabel?.text = fontName["family"]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = pinkTint
        cell.textLabel?.font = UIFont(name: fontName["name"]!, size: 25)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fontName = fontNames[indexPath.row]
        if let field = selectedField(), let size = field.font?.pointSize {
            var text = texts[field.tag]
            text.font = Font(name: fontName["name"]!, size: size)
            texts[field.tag] = text
            field.font = UIFont(name: fontName["name"]!, size: size)
            collage?.kit.texts = texts.filter{ !$0.text.isEmpty }
            toggleInterface(false)
        }
        tableView.isHidden = true
    }
}

// MARK: - ImagePickerDelegate

extension EditorViewController: ImagePickerDelegate {
    
    func imagePickerDelegate(didSelect image: UIImage, delegatedForm: ImagePicker) {
        imagePicker.dismiss()
        
        if let button = backdropImageView.subviews.first(where: {$0.tag == selectedImageIndex}) as? UIButton {
//            button.setBackgroundImage(image, for: .normal)
            button.setImage(image, for: .normal)
            
            if var images = collage?.kit.images, selectedImageIndex < images.count {
                images[selectedImageIndex] = Image(withImage: image)
                collage?.kit.images = images
            }
            else {
                collage?.kit.images = [Image(withImage: image)]
            }
        }
    }
    
    func imagePickerDelegate(didCancel delegatedForm: ImagePicker) { imagePicker.dismiss() }
    
    func imagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        if accessIsAllowed { presentImagePicker(sourceType: .photoLibrary) }
    }
    
    func imagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        // works only on real device (crash on simulator)
        if accessIsAllowed { presentImagePicker(sourceType: .camera) }
    }
}
