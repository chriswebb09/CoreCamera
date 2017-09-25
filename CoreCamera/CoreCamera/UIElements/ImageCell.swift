//
//  ImageCell.swift
//  CoreCamera
//
//  Created by Christopher Webb-Orenstein on 9/20/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

enum CellState {
    case selected, done
}

class ImageCell: UICollectionViewCell {
    
    private var cellState: CellState = .done {
        didSet {
            switch cellState {
            case .selected:
                overlayView.alpha = 0.5
                deleteImageView.alpha = 0.8
            case .done:
                overlayView.alpha = 0
            }
        }
    }
    
    private var deleteImageView: UIImageView = {
        let delete = UIImageView()
        let image = #imageLiteral(resourceName: "circle-x").withRenderingMode(.alwaysTemplate)
        delete.image = image
        delete.tintColor = .white
        return delete
    }()
    
    private var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = .black
        return overlay
    }()
    
    @IBOutlet weak var photoView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
    }
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let path =  UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    private func viewConfigurations() {
        setShadow()
        overlayView.frame = contentView.frame
        contentView.addSubview(overlayView)
        setup(deleteImageView: deleteImageView)
        switch cellState {
        case .selected:
            overlayView.alpha = 0.6
            deleteImageView.alpha = 1
        case .done:
            overlayView.alpha = 0
        }
        bringSubview(toFront: deleteImageView)
    }
    
    func setup(deleteImageView: UIImageView) {
        overlayView.addSubview(deleteImageView)
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: overlayView.frame.height * 0.02).isActive = true
        deleteImageView.leftAnchor.constraint(equalTo: overlayView.leftAnchor, constant: overlayView.frame.width * 0.02).isActive = true
        deleteImageView.heightAnchor.constraint(equalTo: overlayView.heightAnchor, multiplier: 0.21).isActive = true
        deleteImageView.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.18).isActive = true
    }
    
    func configureCell(with mode: CellState) {
        self.layoutSubviews()
        cellState = mode
        if cellState == .done {
            print("done")
        }
    }
}
