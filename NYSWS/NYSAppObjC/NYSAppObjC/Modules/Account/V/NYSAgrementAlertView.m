//
//  NYSAgrementAlertView.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/15.
//

#import "NYSAgrementAlertView.h"

@implementation NYSAgrementAlertView

- (void)setupView {
    ViewRadius(self, 10);
    
    ViewRadius(self.commitBtn, 17.5);
    ViewRadius(self.cancelBtn, 17.5);
    self.cancelBtn.backgroundColor = UIColor.lightGrayColor;
    [self.cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.commitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.commitBtn.backgroundColor = NAppThemeColor;
    self.agreeBtn.selected = YES;
    self.agrementTV.text = NLocalizedStr(@"ProtocolDesc");
}

- (IBAction)cancelBtnOnclicked:(UIButton *)sender {
    if (_block) {
        self.block(@"0");
//        [self removeFromSuperview];
    }
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    if (_block) {
        self.block(@"1");
    }
}

@end
