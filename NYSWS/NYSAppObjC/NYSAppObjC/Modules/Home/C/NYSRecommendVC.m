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
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    [shareBtn setBackgroundColor:UIColor.clearColor];
    [shareBtn addTarget:self action:@selector(shareBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    shareBtn.centerY = kScreenHeight * 0.2;
    
    NSString *str = ShareUrl;
    UIImageView *qrIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.45, kScreenWidth * 0.45)];
    qrIV.image = [SGGenerateQRCode generateQRCodeWithData:str size:RealValue(200) logoImage:[UIImage imageNamed:@"icon_logo"] ratio:NRadius];
    [self.inviteIV addSubview:qrIV];
    
    qrIV.centerX = self.view.centerX;
    qrIV.centerY = kScreenHeight * 0.65;
}

- (void)backBtnOnclicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnOnclicked:(UIButton *)sender {
    UIImage *contentImage = [self.inviteIV snapshotImage];
    
    // 分享
    FFPopup *popup = [FFPopup popupWithContentView:self.shareAlertView showType:FFPopupShowType_BounceInFromBottom dismissType:FFPopupDismissType_BounceOutToBottom maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Left, FFPopupVerticalLayout_Bottom);
    self.shareAlertView.block = ^(NSInteger index, id  _Nonnull obj) {
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
                urlMessage.title = @"邀请你一起学习外国语";
                urlMessage.description = @"海量口碑课程、语言学习中心、聆听世界的声音";
                [urlMessage setThumbImage:[UIImage imageNamed:@"AppIcon"]];
                
                WXWebpageObject *webObj = [WXWebpageObject object];
                webObj.webpageUrl = ShareUrl;
//                WXImageObject *imgObj = [WXImageObject object];
//                imgObj.imageData = UIImagePNGRepresentation(contentImage);

                urlMessage.mediaObject = webObj;
                sendReq.message = urlMessage;
                
                [WXApi sendReq:sendReq];
                
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
                urlMessage.title = @"邀请你一起学习外国语";
                urlMessage.description = @"海量口碑课程、语言学习中心、聆听世界的声音";
                [urlMessage setThumbImage:[UIImage imageNamed:@"AppIcon"]];

                WXWebpageObject *webObj = [WXWebpageObject object];
                webObj.webpageUrl = ShareUrl; // 分享链接
                
                WXImageObject *imgObj = [WXImageObject object];
                imgObj.imageData = UIImagePNGRepresentation(contentImage);

                urlMessage.mediaObject = webObj;
                sendReq.message = urlMessage;
                
                [WXApi sendReq:sendReq];
                
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
