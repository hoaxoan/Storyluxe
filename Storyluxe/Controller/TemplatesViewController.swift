//
//  TemplatesViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 01.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class TemplatesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // Views
    private let tableCellIdentifier = "TableCell"
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height - 99))
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.isHidden = true
        return tableView
    }()
    
    // collection view
    private let leftAndRightPaddings: CGFloat = 40.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let screenSize = UIScreen.main.bounds
    private let cellReuseIdentifier = "CollectionCell"
    private var sets = [TemplateSet]()
    
    // sizes
    private let size = CGSize(width: 35, height: 35)
    private let top: CGFloat = 50
    private let height: CGFloat = 40
    private var previousButton: UIButton?
    private var previousSubButton: UIButton?
    private var series = UIButton()
    
    private let mainScrollView = UIScrollView()
    private let toolbarScrollView = UIScrollView()
    private let subtoolbarScrollView = UIScrollView()
    
    var image: Image?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = blackTint
        setupTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - UI
    
    private func updateUI() {
        sets = Global.shared.templateSets()
        if let items = Global.shared.restore(allTemplatesKey) as [TemplateSet]?, items.count > 0 {
            sets = items
        }
        setupToolbar()
        setupScrollView()
    }
    
    private func setupTitle() {
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
    
    private func setupScrollView() {
        mainScrollView.subviews.forEach{ $0.removeFromSuperview() }
        
        let height = view.frame.height - 180
        mainScrollView.frame = CGRect(x: 0, y: 90, width: view.frame.width, height: height)
        mainScrollView.isPagingEnabled = true

        let allSets = sets.filter {$0.installed }
        allSets.enumerated().forEach { index, _ in
            setupCollectionView(index)
        }
        mainScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(allSets.count), height: height)
        view.addSubview(mainScrollView)
    }
    
    private func setupCollectionView(_ index: Int) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        let frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: mainScrollView.frame.height)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.register(TemplateCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = index
        collectionView.backgroundColor = blackTint
        collectionView.allowsSelection = true
        mainScrollView.addSubview(collectionView)
    }
    
    private func setupToolbar() {
        toolbarScrollView.subviews.forEach{ $0.removeFromSuperview() }
        
        let bottomY = view.bounds.height - height - 40
        toolbarScrollView.backgroundColor = blackTint
        toolbarScrollView.frame = CGRect(x: 10, y: bottomY, width: view.frame.width - 30 - height, height: height)
        
        var offset: CGFloat = 0
        let allSets = sets.filter {$0.installed }
        allSets.enumerated().forEach { index, set in
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
        series.setImage(UIImage(named: "series")?.resize(height - 20), for: .normal)
        series.layer.cornerRadius = 5
        series.layer.masksToBounds = true
        series.addTarget(self, action: #selector(selectSeries), for: .touchUpInside)
        view.addSubview(series)
    }
    
    func setupSubtoolbar(_ index: Int) {
        
        subtoolbarScrollView.subviews.forEach{ $0.removeFromSuperview() }
        subtoolbarScrollView.isHidden = true
        
        var buttons = [String]()
        switch index {
        case 1:
            buttons = buttonsF
        case 3:
            buttons = buttonsP
        case 4:
            buttons = buttonsT
        case 5:
            buttons = buttonsE
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
        sender.setTitleColor(pinkTint, for: .normal)
        if previousSubButton != nil && previousSubButton?.tag != sender.tag {
            previousSubButton!.setTitleColor(.lightGray, for: .normal)
        }
        previousSubButton = sender
    }
    
    @objc func menuForRow(_ sender: UIButton) {
        let set = sets[sender.tag + 1]
        set.installed ? menu(set) : installSet(set)
    }
    
    @objc func selectSeries() {
        view.addSubview(tableView)
        tableView.isHidden = !tableView.isHidden
        series.backgroundColor = tableView.isHidden ? blackTint : .black
        let open = UIImage(named: "series")?.resize(height - 10)
        let close = UIImage(named: "close-white")?.resize(height - 20)
        series.setImage( tableView.isHidden ? open : close, for: .normal)
    }
    
    // MARK: - Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allSets = sets.filter {$0.installed }
        let set = allSets[section].set
        return set.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! TemplateCollectionViewCell
        let allSets = sets.filter {$0.installed }
        let set = allSets[indexPath.section].set
        cell.template = set[indexPath.item]
        return cell
    }
    
    // collection layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width - leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: width, height: width * 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 8, bottom: 20, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let allSets = sets.filter {$0.installed }
        let set = allSets[collectionView.tag].set
        if set[indexPath.item].isPremium && !UserDefaults.standard.bool(forKey: isPurchaseUnlocked) {
            let purchaseVC = PurchaseViewController()
            present(purchaseVC, animated: true, completion: nil)
        }
        else {
            let editorVC = EditorViewController()
            editorVC.collage = newCollage(set[indexPath.item])
            editorVC.modalPresentationStyle = .fullScreen
            present(editorVC, animated: true, completion: nil)
        }
    }
    
    func newCollage(_ template: Template) -> Collage {
        var collage = Collage(isPremium: template.isPremium,
                              kit: Kit(thumbnail: nil,
                                       template: Image(withImage: UIImage(named: template.filename)!),
                                       type: template.type,
                                       aspect: .aspect9_16,
                                       images: nil,
                                       border: nil,
                                       backdrop: nil,
                                       branding: nil,
                                       texts: nil,
                                       canChangeBorder: true))
        if let image = self.image {
            collage.kit.images = [image]
        }
        return collage
    }
    
    // MARK: - Actions
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    private func menu(_ set: TemplateSet) {
        
        let alert = UIAlertController(title: set.title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            var allSets = Global.shared.templateSets()
            if let index = allSets.firstIndex(where: {$0.title == set.title}) {
                allSets[index].installed = false
                Global.shared.save(allSets, key: allTemplatesKey)
                self.selectSeries()
                self.updateUI()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.view.tintColor = pinkTint
        present(alert, animated: true, completion: nil)
    }
    
    private func installSet(_ set: TemplateSet) {
        let installVC = InstallViewController()
        installVC.set = set
        present(installVC, animated: true) {
            self.selectSeries()
        }
    }
}

// MARK: - Table view delegate

extension TemplatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath)
        cell.backgroundColor = .black
        
        let set = sets[indexPath.row]
        cell.textLabel?.text = set.title
        cell.textLabel?.textColor = set.installed ? .white : .lightGray
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        
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
        let set = sets[indexPath.row]
        set.installed ? menu(set) : installSet(set)
    }
}
