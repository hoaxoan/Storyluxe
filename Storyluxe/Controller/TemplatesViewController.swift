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
    let screenSize = UIScreen.main.bounds
    private let cellReuseIdentifier = "CollectionCell"
    var sets = [TemplateSet]()
    
    // sizes
    let size = CGSize(width: 35, height: 35)
    let top: CGFloat = 15
    
    let mainScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = blackTint
        
        sets = Global.shared.testSets()
        if let items = Global.shared.restore(allTemplatesKey) as [TemplateSet]?, items.count > 0 {
            sets = items
        }
        
        setupTitle()
        setupToolbar()
        setupScrollView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupTitle() {
        let width: CGFloat = view.frame.width - 80
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 40, y: top), size: CGSize(width: width, height: size.height)))
        label.textAlignment = .center
        label.textColor = .white
        label.text = "POPULAR"
        label.font = .boldSystemFont(ofSize: 20)
        view.addSubview(label)
        
        let dismiss = Global.shared.button("close-white", CGRect(origin: CGPoint(x: view.frame.width - 50, y: top), size: size), lightGrayTint, .verysmall)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dismiss)
    }
    
    func setupScrollView() {
        let height = view.frame.height - 180
        mainScrollView.backgroundColor = .yellow
        mainScrollView.frame = CGRect(x: 0, y: 65, width: view.frame.width, height: height)
        mainScrollView.isPagingEnabled = true

        sets.enumerated().forEach { index, _ in
            setupCollectionView(CGFloat(index))
        }
        mainScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(sets.count), height: height)
        view.addSubview(mainScrollView)
    }
    
    func setupCollectionView(_ index: CGFloat) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        let frame = CGRect(x: view.frame.width * index, y: 0, width: view.frame.width, height: mainScrollView.frame.height)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.register(TemplateCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = blackTint
        collectionView.allowsSelection = true
        mainScrollView.addSubview(collectionView)
    }
    
    func setupToolbar() {
        
        let height: CGFloat = 40
        let bottomY = view.bounds.height - height - 70
        let scrollView = UIScrollView()
        scrollView.backgroundColor = blackTint
        scrollView.frame = CGRect(x: 10, y: bottomY, width: view.frame.width - 30 - height, height: height)
        
        var offset: CGFloat = 0
        sets.enumerated().forEach { index, set in
            let width = index == 0 ? height : 70
            let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
            button.frame.origin.x = offset
            offset = button.frame.maxX
            button.setTitle(set.title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.titleLabel?.textAlignment = .center
            if set.image != nil {
                button.setImage(set.image?.getImage()?.resize(height - 15), for: .normal)
            }
            button.tag = index
            button.addTarget(self, action: #selector(selectedTemplateSet(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
        }
        scrollView.contentSize = CGSize(width: offset, height: height)
        view.addSubview(scrollView)
        
        let series = UIButton(frame: CGRect(x: scrollView.frame.maxX, y: bottomY, width: height + 10, height: height))
        series.backgroundColor = blackTint
        series.setImage(UIImage(named: "series")?.resize(height - 10), for: .normal)
        series.addTarget(self, action: #selector(selectSeries), for: .touchUpInside)
        view.addSubview(series)
    }
    
    @objc func selectedTemplateSet(_ sender: UIButton) {
        let index = CGFloat(sender.tag)
        mainScrollView.setContentOffset(CGPoint(x: view.frame.width * index, y: 0), animated: true)
    }
    
    @objc func selectSeries() {
        print(#function)
    }
    
    // MARK: - Collection delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let set = sets[section].set
        return set.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! TemplateCollectionViewCell
        let set = sets[indexPath.section].set
        cell.template = set[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editorVC = EditorViewController()
        let set = sets[indexPath.section].set
        editorVC.collage = set[indexPath.item].collage
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
