//
//  ViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 29.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

// https://github.com/Yummypets/YPImagePicker

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    private lazy var imagePicker = ImagePicker()
    
    // collection view
    let leftAndRightPaddings: CGFloat = 50.0
    let numberOfItemsPerRow: CGFloat = 3.0
    let screenSize: CGRect = UIScreen.main.bounds
    private let cellReuseIdentifier = "CollectionCell"
    var items = [Collage]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = blackTint
        imagePicker.delegate = self
        
        items = Global.shared.testCollages()
        if let collages = Global.shared.restore(userCollagesKey) as [Collage]?, collages.count > 0 {
            items = collages
        }
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - UI
    
    func setupUI() {
        // top buttons
        let size = CGSize(width: 35, height: 35)
        
        let email = Global.shared.button("email", CGRect(origin: CGPoint(x: 20, y: 50), size: size), nil)
        email.addTarget(self, action: #selector(showShareVC), for: .touchUpInside)
        view.addSubview(email)
        
        let more = Global.shared.button("more", CGRect(origin: CGPoint(x: view.frame.width - 50, y: 50), size: size), .white, .small)
        more.addTarget(self, action: #selector(showMoreVC), for: .touchUpInside)
        view.addSubview(more)
        
        // images
        let title = UIImageView(image: UIImage(named: "storyluxe-title-white"))
        title.contentMode = .scaleAspectFit
        let width: CGFloat = 135
        title.frame = CGRect(origin: CGPoint(x: (view.frame.width - width)/2, y: 55), size: CGSize(width: width, height: 25))
        view.addSubview(title)
        
        // bottom buttons
        
        let left: CGFloat = 25
        let offset = view.frame.width/3
        var centers = [CGFloat]()
        for i in 0...2 {
            centers.append(CGFloat(i + 1)*offset - 2.7*left)
        }
        
        let (button1, myMedia) = Global.shared.tabButton("media", "My Media", view, centers[0], .white)
        button1.addTarget(self, action: #selector(showMyMedia), for: .touchUpInside)
        view.addSubview(myMedia)
        
        let (button2, templates) = Global.shared.tabButton("templates", "Templates", view, centers[1], .white)
        button2.addTarget(self, action: #selector(showTemplates), for: .touchUpInside)
        view.addSubview(templates)
        
        let (button3, camera) = Global.shared.tabButton("camera", "Camera", view, centers[2], .white)
        button3.addTarget(self, action: #selector(showCamera), for: .touchUpInside)
        view.addSubview(camera)
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        let frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 230)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = blackTint
        collectionView.allowsSelection = true

        self.view.addSubview(collectionView)
    }
    
    // collection delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PreviewCollectionViewCell
        cell.image = items[indexPath.item].set.thumbnail.getImage()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editorVC = EditorViewController()
        editorVC.collage = items[indexPath.item]
        present(editorVC, animated: true, completion: nil)
    }
    // collection layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width - leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: width, height: width * 1.7)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 8, bottom: 5, right: 8)
    }
    
    // MARK: - Button actions
    
    @objc func showShareVC() {
        let inviteVC = InviteViewController()
        present(inviteVC, animated: true, completion: nil)
    }
    
    @objc func showMoreVC() {
        let settingsVC = SettingsTableViewController(style: .grouped)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func showMyMedia() {
        self.imagePicker.photoGalleryAsscessRequest()
    }
    
    @objc func showTemplates() {
        let templatesVC = TemplatesViewController()
        present(templatesVC, animated: true, completion: nil)
    }
    
    @objc func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.cameraAsscessRequest()
        }
        else {
            print("Camera is not available.")
        }
    }
    
    // MARK: - Image Picker
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.imagePicker.present(parent: self, sourceType: sourceType)
        }
    }
}

// MARK: - Delegates

extension MainViewController: ImagePickerDelegate {
    
    func imagePickerDelegate(didSelect image: UIImage, delegatedForm: ImagePicker) {
        imagePicker.dismiss()
        // FIXME: pass image to creator
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

