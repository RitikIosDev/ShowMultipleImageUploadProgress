//
//  CollectionViewCell.swift
//  ShowMultipleImageUploadProgress
//
//  Created by Ritik on 29/05/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var uploadProgressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: UploadTask? {
        didSet {
            guard let model = model else {
                return
            }
            taskTitleLabel.text = model.title
            uploadProgressView.progress = model.progress
        }
    }
}
