//
//  NYSAlertView.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

import UIKit

class AppShareView: UIView {
    
    enum AppShareType {
        case none
        case qq
        case wechat
        case weibo
        case facebook
        case system
    }
    
    enum AppShareAction {
        case confirm
        case close
    }
    typealias AppShareComplete = (_ popup: FFPopup, _ action: AppShareAction, _ type:AppShareType, _ obj: Any?) -> Void
    var complete: AppShareComplete?
    var popup: FFPopup?
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var contentV: UIView!
    @IBOutlet weak var bottomH: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXIB()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureXIB()
        setupView()
    }
    
    private func configureXIB() {
        guard let view = loadViewFromNib() else { return }
        view.backgroundColor = .clear
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        
        return bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
    }
    
    func setupView() {
        self.addRoundedCorners(corners: [.topLeft, .topRight], radius: 15, borderWidth: 0, borderColor: .clear)
        
        iconIV.image = nil
        confirmBtn.backgroundColor = NAppThemeColor
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.addRadius(NAppRadius*2)
        bottomH.constant = UIDevice.nys_isIphoneX() ? NSafeBottomHeight : 20
        
        _ = self.lee_theme.leeConfigBackgroundColor("alert_view_bg_color")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.layoutFittingCompressedSize.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    @IBAction func closeBtnOnclicked(_ sender: UIButton) {
        popup?.dismiss(animated: true)
        
        if let complete = complete {
            complete(popup!, .close, .none, "")
        }
    }
    
    @IBAction func confirmBtnOnclicked(_ sender: UIButton) {
        
        if let complete = complete {
            complete(popup!, .confirm, .none, "")
        } else {
            popup?.dismiss(animated: true)
        }
    }
}

extension AppShareView {
    
    func configure(content: Any?, icon: UIImage?, confirmButtonTitle: String?) {
        iconIV.image = icon
        confirmBtn.setTitle(confirmButtonTitle, for: .normal)
        // TODO: - content
        
        
    }
    
}
