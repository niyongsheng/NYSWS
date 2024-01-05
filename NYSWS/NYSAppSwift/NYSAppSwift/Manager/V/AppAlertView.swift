//
//  NYSAlertView.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

import UIKit

class AppAlertView: UIView {
    
    enum AppAlertAction {
        case confirm
        case cancel
        case close
    }
    typealias AppAlertComplete = (_ popup: FFPopup, _ action: AppAlertAction, _ obj: Any?) -> Void
    var complete: AppAlertComplete?
    var popup: FFPopup?
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
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
        self.addRadius(15)
        
        iconIV.image = nil
        titleL.text = nil
        contentL.text = nil
        
        confirmBtn.backgroundColor = NAppThemeColor
        confirmBtn.setTitleColor(.white, for: .normal)
        cancelBtn.setTitleColor(NAppThemeColor, for: .normal)
        
        confirmBtn.addRadius(NAppRadius)
        cancelBtn.addCornerRadius(NAppRadius, borderWidth: 1, borderColor: NAppThemeColor)

        _ = self.lee_theme.leeConfigBackgroundColor("alert_view_bg_color")
        _ = self.titleL.lee_theme.leeConfigTextColor("default_nav_bar_title_color")
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
            complete(popup!, .close, "")
        }
    }
    
    @IBAction func cancelBtnOnclicked(_ sender: UIButton) {
        popup?.dismiss(animated: true)
        
        if let complete = complete {
            complete(popup!, .cancel, "")
        }
    }
    
    @IBAction func confirmBtnOnclicked(_ sender: UIButton) {
        
        if let complete = complete {
            complete(popup!, .confirm, "")
        } else {
            popup?.dismiss(animated: true)
        }
    }
}

extension AppAlertView {
    
    func configure(title: String?, content: String?, icon: UIImage?, confirmButtonTitle: String?, cancelBtnTitle: String?) {
        titleL.text = title
        contentL.text = content
        iconIV.image = icon
        confirmBtn.isHidden = confirmButtonTitle == nil
        cancelBtn.isHidden = cancelBtnTitle == nil
        confirmBtn.setTitle(confirmButtonTitle, for: .normal)
        cancelBtn.setTitle(cancelBtnTitle, for: .normal)
    }
    
}
