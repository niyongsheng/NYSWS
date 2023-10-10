//
//  NYSAlertView.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/15.
//

#import "NYSAlertView.h"

@implementation NYSAlertView

- (void)setupView {
    ViewRadius(self, 10);
    
    ViewBorderRadius(self.cancelBtn, 20, 1, NAppThemeColor);
    ViewRadius(self.commitBtn, 20);
    [self.cancelBtn setTitleColor:NAppThemeColor forState:UIControlStateNormal];
    [self.commitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.commitBtn.backgroundColor = NAppThemeColor;
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
