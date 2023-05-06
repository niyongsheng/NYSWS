//
//  NYSMineViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.

#import "NYSFeedbackVC.h"

#import "NYSSettingViewController.h"
#import "NYSCallCenterVC.h"
#import "NYSMessageCenterVC.h"
#import "NYSHelpViewController.h"
#import "NYSAboutViewController.h"
#import "NYSWalletViewController.h"
#import "NYSSecurityProtectionVC.h"

@interface NYSFeedbackVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet UITextView *contentT;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation NYSFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    ViewRadius(_commitBtn, 22.5f)
    
    ViewBorderRadius(_btn0, 2.0f, 0.7, UIColor.lightGrayColor);
    ViewBorderRadius(_btn1, 2.0f, 0.7, UIColor.lightGrayColor);
    ViewBorderRadius(_btn2, 2.0f, 0.7, UIColor.lightGrayColor);
    
    ViewBorderRadius(_addBtn, 2.0f, 0.7, UIColor.lightGrayColor);
    ViewBorderRadius(_contentV, 2.0f, 0.7, UIColor.lightGrayColor);
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    
    
}


@end
