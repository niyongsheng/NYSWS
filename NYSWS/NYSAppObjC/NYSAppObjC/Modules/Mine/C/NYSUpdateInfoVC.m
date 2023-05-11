//
//  NYSUpdateInfoVC.m
//  LKXiaoLuZSB
//
//  Created by niyongsheng on 2022/9/28.
//  Copyright © 2022 niyongsheng. All rights reserved.
//

#import "NYSUpdateInfoVC.h"

@interface NYSUpdateInfoVC ()
{
    NSString *_iconUrl;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIView *iconV;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation NYSUpdateInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";

    _iconUrl = @"";
    ViewRadius(_commitBtn, 22.5f)
    ViewBorderRadius(_iconIV, 20, 1, UIColor.whiteColor);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    _iconUrl = NAppManager.userInfo.avatar;
    self.remarkTF.text = NAppManager.userInfo.nickname;
    [self.iconIV setImageWithURL:NCDNURL(_iconUrl) placeholder:NPImageFillet];
    
    @weakify(self)
    self.iconV.userInteractionEnabled = YES;
    [self.iconV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
        
        ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
        ac.configuration.navTitleColor = NAppThemeColor;
        ac.configuration.maxSelectCount = 1;
        ac.configuration.maxPreviewCount = 0;
        ac.configuration.allowEditImage = YES;
        ac.sender = self;
        [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            @strongify(self)
            [self uploadAvator:images];
        }];
        [ac showPreviewAnimated:YES];
        

    }]];
}

/// 上传头像
/// - Parameter images: 图片数组
- (void)uploadAvator:(NSArray<UIImage *> *) images {
    @weakify(self)
    [NYSNetRequest uploadImagesWithType:POST
                                    url:@"/index/Index/upload"
                               argument:nil
                                   name:@"file"
                                 files:images
                              fileNames:nil
                             imageScale:0.5
                              imageType:nil
                                 remark:@"头像上传"
                               progress:^(NSProgress * _Nonnull process) {
        
    } success:^(NSDictionary * _Nullable response) {
        @strongify(self)
        self.iconIV.image = [images firstObject];
        self->_iconUrl = [response stringValueForKey:@"src" default:@""];
        
    } failed:^(NSError * _Nullable error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    
    if (![_remarkTF.text isNotBlank]) {
        [NYSTools showToast:@"请输入昵称"];
        return;
    }
    
    NSMutableDictionary *params = @{
        @"nickname": _remarkTF.text,
        @"avatar": _iconUrl
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Member/update_information"
                                      argument:params
                                             remark:@"修改个人资料"
                                            success:^(id response) {
        // 刷新用户信息
        [NAppManager loadUserInfoCompletion:nil];
        
        @strongify(self)
        [NYSTools showIconToast:@"已更新" isSuccess:YES offset:UIOffsetMake(0, 0)];
        [NYSTools dismissWithDelay:1.0f completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];

    } failed:^(NSError * _Nullable error) {


    }];
    
}


@end
