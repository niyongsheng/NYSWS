//
//  NYSTextAlertView.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/23.
//

import UIKit

class NYSTextAlertView: NYSRootAlertView {

    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var closeBtn: UIButton!
    
    typealias NYSOverdueAlertComplete = (_ popup: FFPopup, _ action: AppAlertAction, _ obj: Any?) -> Void
    var complete: NYSOverdueAlertComplete?
    var popup: FFPopup?
    
    override func setupView() {
        super.setupView()
        
        self.addRadius(NAppSpace)
    }
    
    @IBAction func closeBtnOnclicked(_ sender: UIButton) {
        popup?.dismiss(animated: true)
        
        if let complete = complete {
            complete(popup!, .close, "")
        }
    }

}
