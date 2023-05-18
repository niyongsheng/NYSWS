//
//  NYSAboutViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSHelpViewController.h"
#import "NYSHelpContentVC.h"

@interface NYSHelpViewController ()

@end

@implementation NYSHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NLocalizedStr(@"HelpCenter");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
}

- (IBAction)itemViewOnclicked1:(UIButton *)sender {
    NYSHelpContentVC *vc = NYSHelpContentVC.new;
    vc.index = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)itemViewOnclicked2:(UIButton *)sender {
    NYSHelpContentVC *vc = NYSHelpContentVC.new;
    vc.index = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
