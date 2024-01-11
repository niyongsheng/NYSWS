//
//  NYSCourseExchangeVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCourseExchangeVC.h"

@interface NYSCourseExchangeVC ()
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UILabel *coinL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *infoL;


@property (weak, nonatomic) IBOutlet UIView *codeV;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation NYSCourseExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NLocalizedStr(@"Active");
    [self wr_setNavBarBarTintColor:NAppThemeColor];
    [self wr_setNavBarTitleColor:UIColor.whiteColor];
    
    self.view.backgroundColor = NAppThemeColor;
    self.customStatusBarStyle = UIStatusBarStyleLightContent;
    
    ViewRadius(_contentV, 30);
    ViewRadius(_commitBtn, 22.5);
    self.timeL.adjustsFontSizeToFitWidth = YES;
    self.infoL.adjustsFontSizeToFitWidth = YES;
    self.subtitleL.adjustsFontSizeToFitWidth = YES;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon_night"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.iconIV setImageWithURL:NCDNURL(self.detailModel.image) placeholder:NPImageFillet];
    self.titleL.text = self.detailModel.name;
    self.subtitleL.text = self.detailModel.subtitle;
    self.coinL.text = self.detailModel.price;
    self.timeL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"UpdateTime"), [NYSTools transformTimestampToTime:self.detailModel.updatetime * 1000 format:nil]];
    self.infoL.text = [NSString stringWithFormat:@"%@：%.2fMB   %@：%@",
                       NLocalizedStr(@"CourseSize"), self.detailModel.size, NLocalizedStr(@"CourseVersion"), self.detailModel.version];
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender.layer];
    
    if (![_codeTF.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsConvertCode")];
        return;
    }
    
    NSMutableDictionary *params = @{
        @"activation_code": self.codeTF.text,
        @"course_id": @(self.detailModel.ID)
    }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Course/activation"
                                       parameters:params
                                         remark:@"激活课程"
                                        success:^(id response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NNotificationReloadData" object:nil];
        
        @strongify(self)
        NYSAlertView *alertView = [[NYSAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.75, RealValue(220))];
        alertView.cancelBtn.hidden = YES;
        alertView.titleL.text = NLocalizedStr(@"ActiveSuccess");
        alertView.block = ^(id obj) {
            [FFPopup dismissAllPopups];
            
            if ([obj isEqual:@"1"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        };
        FFPopup *popup = [FFPopup popupWithContentView:alertView showType:FFPopupShowType_BounceIn dismissType:FFPopupDismissType_ShrinkOut maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
        FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Center, FFPopupVerticalLayout_Center);
        [popup showWithLayout:layout];
        
        // 更新缓存
        [NAppManager cacheAudioData:YES isRecache:YES];
        
    } failed:^(NSError * _Nullable error) {
        
        
    }];
}

@end
