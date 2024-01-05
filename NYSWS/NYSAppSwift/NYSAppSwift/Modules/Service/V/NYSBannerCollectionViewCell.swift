//
//  NYSBannerCollectionViewCell.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/29.
//

import UIKit

class NYSBannerCollectionViewCell: UICollectionViewCell {
    
    private lazy var bannerIV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    var urlStr: String = "" {
        didSet {
            if let url = URL(string: urlStr) {
                DispatchQueue.global(qos: .background).async {
                    self.bannerIV.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image_fillet"))
                    
                    DispatchQueue.main.async {
                        // 在主线程中更新UI或处理任务结果
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bannerIV.frame = contentView.bounds
        contentView.addSubview(bannerIV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
