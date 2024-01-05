//
//  NYSQRCodeViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

import UIKit

private let NAVBAR_TRANSLATION_POINT:CGFloat = -NTopHeight

class NYSQRCodeViewController: NYSRootViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    
    @IBOutlet weak var qrCodeIV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "二维码"
        
        DispatchQueue.global(qos: .default).async {
            let qrImg = SGGenerateQRCode.generateQRCode(withData: "https://github.com/niyongsheng", size: 200, color: NAppThemeColor, backgroundColor: .clear)
            
            DispatchQueue.main.async {
                self.qrCodeIV.image = qrImg
            }
        }
    }

    private func generateQRCode(withData data: String, size: CGFloat, color: UIColor, backgroundColor: UIColor) -> UIImage? {
        guard let stringData = data.data(using: .utf8),
              let filter = CIFilter(name: "CIQRCodeGenerator"),
              let ciImage = filter.outputImage else {
            return nil
        }
        
        filter.setValue(stringData, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let colorFilter = CIFilter(name: "CIFalseColor"),
              let outputImage = colorFilter.outputImage else {
            return nil
        }
        
        colorFilter.setValue(ciImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(cgColor: color.cgColor), forKey: "inputColor0")
        colorFilter.setValue(CIColor(cgColor: backgroundColor.cgColor), forKey: "inputColor1")
        
        let scale = size / outputImage.extent.size.width
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        guard let cgImage = CIContext().createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        
        let qrCodeImage = UIImage(cgImage: cgImage)
        return qrCodeImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavigationBarTransformProgress(progress: 0)
    }
    
    override func setupUI() {
        super.setupUI()
        
        navBarBackgroundAlpha = 1
        self.scrollView.delegate = self

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("offsetY: \(offsetY)")
        if (offsetY > NAVBAR_TRANSLATION_POINT) {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let weakSelf = self {
                    weakSelf.setNavigationBarTransformProgress(progress: 1)
                }
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let weakSelf = self {
                    weakSelf.setNavigationBarTransformProgress(progress: 0)
                }
            })
        }
    }
    
    private func setNavigationBarTransformProgress(progress:CGFloat) {
        navigationController?.navigationBar.wr_setTranslationY(translationY: -CGFloat(NTopHeight) * progress)
        navigationController?.navigationBar.wr_setBarButtonItemsAlpha(alpha: 1 - progress, hasSystemBackIndicator: true)
    }
}
