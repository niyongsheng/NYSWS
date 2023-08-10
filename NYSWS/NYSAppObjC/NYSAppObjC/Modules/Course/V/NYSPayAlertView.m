//
//  NYSPayAlertView.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/15.
//

#import "NYSPayAlertView.h"

@implementation NYSPayAlertView

- (void)setupView {
    ViewRadius(self, 10);
    
    ViewBorderRadius(self.commitBtn, 23, 1, NAppThemeColor);
    self.commitBtn.backgroundColor = NAppThemeColor;
    self.commitBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.commitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
}

- (IBAction)cancelBtnOnclicked:(UIButton *)sender {
    if (_block) {
        self.block(@"0");
    }
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    if (_block) {
        self.block(@"1");
    }
}

@end
