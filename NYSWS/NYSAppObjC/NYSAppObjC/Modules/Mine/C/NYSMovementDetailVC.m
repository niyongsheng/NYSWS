//
//  NYSAboutViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSMovementDetailVC.h"

@interface NYSMovementDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *wayL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *orderL;

@end

@implementation NYSMovementDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账单详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
   
}

- (void)setModel:(NYSMovementModel *)model {
    _model = model;
    
    
}

@end
