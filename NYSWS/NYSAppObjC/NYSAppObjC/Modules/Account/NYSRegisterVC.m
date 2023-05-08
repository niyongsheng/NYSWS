//
//  NYSRegisterVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSRegisterVC.h"

@interface NYSRegisterVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;




@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation NYSRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    
    
    ViewRadius(_commitBtn, 22.5f)
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    
}

@end
