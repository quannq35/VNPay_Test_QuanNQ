//
//  PhotoTableViewCell.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 4/6/25.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var sizeImageLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
        
    var currentImageURL: URL?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Xóa dữ liệu cũ trong cell trước khi cell được tái sử dụng tránh việc dữ liệu hiển thị nhầm cell
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImg.image = nil
        currentImageURL = nil
    }
    
    func configuration(photo: PhotoModel) {
        self.authorLabel.text = photo.author
        
        if let width = photo.width, let height = photo.height {
            self.sizeImageLabel.text = "Size: \(width) x \(height)"
        } else {
            self.sizeImageLabel.text = "Size: Chưa có đầy đủ kích thước"
        }
    }
    
    func setImage(image: UIImage?) {
        photoImg.image = image
    }
}

