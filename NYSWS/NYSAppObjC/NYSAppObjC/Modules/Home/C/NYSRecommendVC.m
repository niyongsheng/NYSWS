//
//  NYSRecommendVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSRecommendVC.h"
#import "NYSShareAlertView.h"
#import <SGQRCode/SGQRCode.h>

#define ShareUrl @"http://xyd.app12345.cn/h5"

@interface NYSRecommendVC ()
@property (weak, nonatomic) IBOutlet UIImageView *inviteIV;
/// 分享弹框
@property(nonatomic, strong) NYSShareAlertView *shareAlertView;
/// 宣传语
@property (strong, nonatomic) NSArray *dataArr;

/// 分享链接
@property (strong, nonatomic) NSString *shearUrl;
@end

@implementation NYSRecommendVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self wr_setNavBarBackgroundAlpha:0];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addTarget:self action:@selector(backBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    ViewRadius(shareBtn, 15)
    [shareBtn setBackgroundColor:UIColor.whiteColor];
    [shareBtn setTitle:NLocalizedStr(@"Share") forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [shareBtn addTarget:self action:@selector(shareBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    self.shearUrl = [NSString stringWithFormat:@"%@?tj_code=%@&os=ios", ShareUrl, NAppUser.invite_code];
    UIImageView *qrIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.45, kScreenWidth * 0.45)];
    qrIV.contentMode = UIViewContentModeScaleToFill;
    qrIV.image = [UIImage imageNamed:@"qr_code_bg"];
    [self.inviteIV addSubview:qrIV];
    qrIV.centerX = kScreenWidth * 0.5;
    qrIV.centerY = kScreenHeight * 0.65;
    
    // 异步加载二维码
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        UIImage *image = [SGGenerateQRCode generateQRCodeWithData:self.shearUrl size:RealValue(200) logoImage:[UIImage imageNamed:@"icon_logo"] ratio:NRadius];
        dispatch_async(dispatch_get_main_queue(), ^{
            qrIV.image = image;
        });
    });
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Member/get_xuanchuanyu"
                                       parameters:nil
                                         remark:@"获取分享宣传语"
                                        success:^(id response) {
        @strongify(self)
        self.dataArr = response;

    } failed:^(NSError * _Nullable error) {

    }];
}

- (void)backBtnOnclicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnOnclicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender.layer];
    UIImage *contentImage = [self.inviteIV snapshotImage];
    
    // 分享
    FFPopup *popup = [FFPopup popupWithContentView:self.shareAlertView showType:FFPopupShowType_BounceInFromBottom dismissType:FFPopupDismissType_BounceOutToBottom maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Left, FFPopupVerticalLayout_Bottom);
    @weakify(self)
    self.shareAlertView.block = ^(NSInteger index, id  _Nonnull obj) {
        @strongify(self)
        [popup dismissAnimated:YES];
        switch (index) {
            case 0:
                [popup dismissAnimated:YES];
                break;
                
            case 1: {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    // 写入图片到相册
                    [PHAssetChangeRequest creationRequestForAssetFromImage:contentImage];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        [NYSTools showToast:@"保存成功"];
                    } else {
                        [NYSTools showToast:[NSString stringWithFormat:@"报错失败:%@", error.localizedDescription]];
                    }
                }];
            }
                break;
                
            case 2: {
                if (![WXApi isWXAppInstalled]) {
                    [NYSTools showToast:@"尚未安装微信"];
                    return;
                }
                
                SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
                sendReq.bText = NO;
                sendReq.scene = WXSceneTimeline;

                WXMediaMessage *urlMessage = [WXMediaMessage message];
                NSString *title = [[self.dataArr firstObject] stringValueForKey:@"value" default:@"邀请你一起学习外国语"];
                NSString *description = @"";
                if (self.dataArr.count > 1) {
                    description = [self.dataArr[1] stringValueForKey:@"value" default:@"海量口碑课程、语言学习中心、聆听世界的声音"];
                }
                urlMessage.title = title;
                urlMessage.description = description;
                [urlMessage setThumbImage:[UIImage imageNamed:@"AppIcon"]];
                
                WXWebpageObject *webObj = [WXWebpageObject object];
                webObj.webpageUrl = self.shearUrl;
//                WXImageObject *imgObj = [WXImageObject object];
//                imgObj.imageData = UIImagePNGRepresentation(contentImage);

                urlMessage.mediaObject = webObj;
                sendReq.message = urlMessage;
                
                [WXApi sendReq:sendReq completion:nil];
                
            }
                break;
                
            case 3: {
                if (![WXApi isWXAppInstalled]) {
                    [NYSTools showToast:@"尚未安装微信"];
                    return;
                }
                
                SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
                sendReq.bText = NO;
                sendReq.scene = WXSceneSession;

                WXMediaMessage *urlMessage = [WXMediaMessage message];
                NSString *title = [[self.dataArr firstObject] stringValueForKey:@"value" default:@"邀请你一起学习外国语"];
                NSString *description = @"";
                if (self.dataArr.count > 1) {
                    description = [self.dataArr[1] stringValueForKey:@"value" default:@"海量口碑课程、语言学习中心、聆听世界的声音"];
                }
                urlMessage.title = title;
                urlMessage.description = description;
                [urlMessage setThumbImage:[UIImage imageNamed:@"AppIcon"]];

                WXWebpageObject *webObj = [WXWebpageObject object];
                webObj.webpageUrl = self.shearUrl;
                
                WXImageObject *imgObj = [WXImageObject object];
                imgObj.imageData = UIImagePNGRepresentation(contentImage);

                urlMessage.mediaObject = webObj;
                sendReq.message = urlMessage;
                
                [WXApi sendReq:sendReq completion:nil];
            }
                break;
                
            case 4: {
                [NYSTools systemShare:@[contentImage] controller:self completion:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                    
                }];
            }
                break;
                
            default:
                break;
        }
    };
    [popup showWithLayout:layout];
}

- (NYSShareAlertView *)shareAlertView {
    if (!_shareAlertView) {
        CGFloat width = kScreenWidth;
        CGFloat height = (5 + 1) * 50 + NBottomHeight;
        _shareAlertView = [[NYSShareAlertView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    }
    return _shareAlertView;
}

@end
