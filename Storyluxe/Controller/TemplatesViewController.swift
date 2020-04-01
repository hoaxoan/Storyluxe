//
//  TemplatesViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 01.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class TemplatesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // collection view
    let leftAndRightPaddings: CGFloat = 40.0
    let numberOfItemsPerRow: CGFloat = 2.0
    let screenSize = UIScreen.main.bounds
    private let cellReuseIdentifier = "CollectionCell"
    var sets = [TemplateSet]()
    
    // sizes
    let size = CGSize(width: 35, height: 35)
    let top: CGFloat = 15
    let height: CGFloat = 40
    var previousButton: UIButton?
    var previousSubButton: UIButton?
    var series = UIButton()
    
    let mainScrollView = UIScrollView()
    let toolbarScrollView = UIScrollView()
    let subtoolbarScrollView = UIScrollView()
    
    // MARK: - Lifecycle
    
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
        setupTableView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - UI
    
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
        let bottomY = view.bounds.height - height - 70
        toolbarScrollView.backgroundColor = blackTint
        toolbarScrollView.frame = CGRect(x: 10, y: bottomY, width: view.frame.width - 30 - height, height: height)
        
        var offset: CGFloat = 0
        sets = sets.filter {$0.installed }
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
            toolbarScrollView.addSubview(button)
        }
        toolbarScrollView.contentSize = CGSize(width: offset, height: height)
        view.addSubview(toolbarScrollView)
        
        series = UIButton(frame: CGRect(x: toolbarScrollView.frame.maxX, y: bottomY, width: height + 10, height: height))
        series.backgroundColor = blackTint
        series.setImage(UIImage(named: "series")?.resize(height - 10), for: .normal)
        series.addTarget(self, action: #selector(selectSeries), for: .touchUpInside)
        view.addSubview(series)
    }
    
    func setupSubtoolbar(_ index: Int) {
        
        subtoolbarScrollView.subviews.forEach{ $0.removeFromSuperview() }
        subtoolbarScrollView.isHidden = true
        
        var buttons = [String]()
        switch index {
        case 1:
            buttons = ["F8", "F7", "F6", "F5", "F4", "F3", "F2", "F1",]
        case 3:
            buttons = ["P4", "P3", "P2", "P1",]
        case 4:
            buttons = ["T6", "T5", "T4", "T3", "T2", "T1",]
        case 5:
            buttons = ["E5", "E4", "E3", "E2", "E1",]
        default: break }
        
        guard buttons.count > 0 else { return }
        subtoolbarScrollView.isHidden = false
        subtoolbarScrollView.backgroundColor = blackTint
        subtoolbarScrollView.frame = CGRect(x: 0, y: toolbarScrollView.frame.minY - height, width: view.frame.width, height: height)
        var offset: CGFloat = 0
        buttons.enumerated().forEach { index, name in
            let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: height)))
            button.frame.origin.x = offset
            offset = button.frame.maxX
            button.setTitle(name, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.tag = index
            button.addTarget(self, action: #selector(selectedTemplateSubset(_:)), for: .touchUpInside)
            subtoolbarScrollView.addSubview(button)
        }
        subtoolbarScrollView.contentSize = CGSize(width: offset, height: height)
        view.addSubview(subtoolbarScrollView)
    }
    
    var tableView = UITableView()
    let tableCellIdentifier = "TableCell"
    let allSets = Array(Global.shared.testSets().dropFirst())
    func setupTableView() {
        tableView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height - 115))
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        view.addSubview(tableView)
        tableView.isHidden = true
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath)
        cell.backgroundColor = .black
        
        let set = allSets[indexPath.row]
        cell.textLabel?.text = set.title
        cell.textLabel?.textColor = set.installed ? .white : .lightGray
        cell.textLabel?.font = .boldSystemFont(ofSize: 14)
        
        let imageCheck = UIImage(named: "check-black")?.tint(color: pinkTint).resize(size.width - 20)
        let imagePlus = UIImage(named: "plus-small")?.tint(color: .lightGray).resize(size.width - 20)
        cell.imageView?.image = set.installed ? imageCheck : imagePlus
        
        let button = UIButton(frame: CGRect(origin: .zero, size: size))
        button.tag = indexPath.row
        button.setImage(UIImage(named: set.installed ? "more" : "eye")?.tint(color: .lightGray).resize(size.width - 10), for: .normal)
        button.addTarget(self, action: #selector(menuForRow(_:)), for: .touchUpInside)
        cell.accessoryView = button
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @objc func selectedTemplateSet(_ sender: UIButton) {
        let index = CGFloat(sender.tag)
        sender.setTitleColor(pinkTint, for: .normal)
        if previousButton != nil && previousButton?.tag != sender.tag {
            previousButton!.setTitleColor(.lightGray, for: .normal)
        }
        mainScrollView.setContentOffset(CGPoint(x: view.frame.width * index, y: 0), animated: true)
        if mainScrollView.frame.maxX < (sender.frame.maxX + 30) {
            var scrollFrame = sender.frame
            scrollFrame.origin.x += 50
            toolbarScrollView.scrollRectToVisible(scrollFrame, animated: true)
        }
        previousButton = sender
        setupSubtoolbar(sender.tag)
    }
    
    @objc func selectedTemplateSubset(_ sender: UIButton) {
        let index = CGFloat(sender.tag)
        sender.setTitleColor(pinkTint, for: .normal)
        if previousSubButton != nil && previousSubButton?.tag != sender.tag {
            previousSubButton!.setTitleColor(.lightGray, for: .normal)
        }
//        mainScrollView.setContentOffset(CGPoint(x: view.frame.width * index, y: 0), animated: true)
        previousSubButton = sender
    }
    
    @objc func menuForRow(_ sender: UIButton) {
        print(#function)
    }
    
    @objc func selectSeries() {
        tableView.isHidden = !tableView.isHidden
        series.backgroundColor = tableView.isHidden ? blackTint : .black
        let open = UIImage(named: "series")?.resize(height - 10)
        let close = UIImage(named: "close-white")?.resize(height - 20)
        series.setImage( tableView.isHidden ? open : close, for: .normal)
    }
    
    // MARK: - Collection view delegate
    
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
        let set = sets[indexPath.section].set
        if set[indexPath.item].isPremium {
            let purchaseVC = PurchaseViewController()
            present(purchaseVC, animated: true, completion: nil)
        }
        else {
            let editorVC = EditorViewController()
            editorVC.collage = set[indexPath.item].collage
            present(editorVC, animated: true, completion: nil)
        }
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
