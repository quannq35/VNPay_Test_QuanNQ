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
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
        
    var currentImageURL: URL?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLoadingImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.loadingIndicator.center = self.center
    }
    
    // Xóa dữ liệu cũ trong cell trước khi cell được tái sử dụng tránh việc dữ liệu hiển thị nhầm cell
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImg.image = nil
        currentImageURL = nil
        loadingIndicator.stopAnimating()
    }
    
    private func setupLoadingImage() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: photoImg.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: photoImg.centerYAnchor),
        ])
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
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
        self.loadingIndicator.stopAnimating()
    }
}

