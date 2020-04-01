//
//  TemplatesViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 01.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class TemplatesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    // collection view
    let leftAndRightPaddings: CGFloat = 40.0
    let numberOfItemsPerRow: CGFloat = 2.0
    let screenSize: CGRect = UIScreen.main.bounds
    private let cellReuseIdentifier = "CollectionCell"
    var items = [["frame": "instant_1f", "type": FrameType.one],
                 ["frame": "instant_2f", "type": FrameType.two],
                 ["frame": "instant_3f", "type": FrameType.three],
                 ["frame": "instant_4f", "type": FrameType.four]]
    
    // sizes
    let size = CGSize(width: 35, height: 35)
    let top: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = blackTint
        
        // title
        let width: CGFloat = view.frame.width - 80
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 40, y: top), size: CGSize(width: width, height: size.height)))
        label.textAlignment = .center
        label.textColor = .white
        label.text = "POPULAR"
        label.font = .boldSystemFont(ofSize: 20)
        view.addSubview(label)
        
        // close button
        let dismiss = Global.shared.button("close-white", CGRect(origin: CGPoint(x: view.frame.width - 50, y: top), size: size), lightGrayTint, .verysmall)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dismiss)
        
        setupCollectionView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        let frame = CGRect(x: 0, y: 65, width: view.frame.width, height: view.frame.height - 180)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.register(TemplateCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! TemplateCollectionViewCell
        cell.image = UIImage(named: items[indexPath.item]["frame"] as! String)
        cell.frameType = items[indexPath.item]["type"] as? FrameType
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let editorVC = EditorViewController()
        present(editorVC, animated: true, completion: nil)
    }
    // collection layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width - leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: width, height: width * 1.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 8, bottom: 20, right: 8)
    }

    // MARK: - Actions
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
