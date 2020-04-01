//
//  PreviewCollectionViewCell.swift
//  Storyluxe
//
//  Created by Sergey Koval on 30.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            preview.image = image
        }
    }
    
    override var isSelected: Bool {
      didSet {
        preview.layer.borderWidth = isSelected ? 3.0 : 0.0
      }
    }
    
    private let preview: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = pinkTint.cgColor
        imageView.layer.borderWidth = 0.0
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        preview.frame = bounds
        addSubview(preview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
