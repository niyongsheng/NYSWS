//
//  NYSUpdateInfoVC.m
//  LKXiaoLuZSB
//
//  Created by niyongsheng on 2022/9/28.
//  Copyright © 2022 niyongsheng. All rights reserved.
//

#import "NYSSecurityProtectionVC.h"

@interface NYSSecurityProtectionVC ()
{
    NSString *_iconUrl;
}

@property (weak, nonatomic) IBOutlet UILabel *questionL;
@property (weak, nonatomic) IBOutlet UITextField *answerTF;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation NYSSecurityProtectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NLocalizedStr(@"SecurityQuestion");

    ViewRadius(_commitBtn, 22.5f)
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    self.questionL.text = NAppManager.userInfo.security_question;
    self.answerTF.text = NAppManager.userInfo.security_answer;
    
    self.questionL.userInteractionEnabled = YES;
    [self.questionL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        BRStringPickerView *stringPickerView = [[BRStringPickerView alloc] init];
        stringPickerView.pickerMode = BRStringPickerComponentSingle;
        stringPickerView.title = NLocalizedStr(@"SecurityQuestionTitle");
        stringPickerView.dataSourceArr = @[
            NLocalizedStr(@"SecurityQuestion1"),
            NLocalizedStr(@"SecurityQuestion2"),
            NLocalizedStr(@"SecurityQuestion3"),
            NLocalizedStr(@"SecurityQuestion4"),
            NLocalizedStr(@"SecurityQuestion5"),
        ];
        stringPickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            self.questionL.text = resultModel.value;
        };
        
        // 设置自定义样式
        UIColor *color = NAppThemeColor;
        BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:color];
        customStyle.selectRowTextColor = color;
        customStyle.topCornerRadius = 1.5*NRadius;
        stringPickerView.pickerStyle = customStyle;
        
        [stringPickerView show];
    }]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    
    if (![_answerTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsSecurityQuestionAnswer")];
        return;
    }
    
    if (self.answerTF.text.length < 1 || self.answerTF.text.length > 16) {
        [NYSTools showToast:NLocalizedStr(@"TipsSecurityQuestionAnswerLength")];
        [NYSTools shakeAnimation:self.answerTF.layer];
        return;
    }
    
    NSMutableDictionary *params = @{
        @"phone": NAppManager.userInfo.phone,
        @"security_question": _questionL.text,
        @"security_answer": _answerTF.text,
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Member/update_security"
                                      argument:params
                                             remark:@"修改密保答案"
                                            success:^(id response) {
        @strongify(self)
        [NYSTools showIconToast:NLocalizedStr(@"Updated") isSuccess:YES offset:UIOffsetMake(0, 0)];
        [NYSTools dismissWithDelay:1.0f completion:^{
            // 刷新用户信息
            [NAppManager loadUserInfoCompletion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(NSError * _Nullable error) {


    }];
}


@end
