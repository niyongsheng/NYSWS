//
//  NYSAgrementAlertView.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/15.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSAgrementAlertView : NYSBaseView
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UITextView *agrementTV;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (copy, nonatomic) NYSBlock block;
@end

NS_ASSUME_NONNULL_END
