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
#import "LLImagePickerView.h"

@interface NYSFeedbackVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) NSString *selectedBtnIndex;

@property (weak, nonatomic) IBOutlet UIView *imageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVHeight;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (strong, nonatomic) NSMutableArray<UIImage *> *selectedImagesArray;
@property (strong, nonatomic) NSMutableArray<NSString *> *selectedImagesUrlArray;
@property (strong, nonatomic) LLImagePickerView *pickerView;
@property (strong, nonatomic) UILabel *placeHolderLabel;
@end

@implementation NYSFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NLocalizedStr(@"Feedback");
    ViewRadius(_commitBtn, 22.5f)
    
    self.btn0.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.btn1.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.btn2.titleLabel.adjustsFontSizeToFitWidth = YES;
    ViewBorderRadius(_contentV, 2.0f, 0.7, UIColor.lightGrayColor);
    self.selectedBtnIndex = @"-1";
    [self typeBtnOnclicked:self.btn0];
    
    // TextView添加占位符
    [_contentTV addSubview:self.placeHolderLabel];
    [_contentTV setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
    
    // 图片选择器
    [self.imageV addSubview:self.pickerView];
    
    @weakify(self)
    [self.pickerView observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        @strongify(self)
        [self.selectedImagesArray removeAllObjects];
        NSMutableArray *selectedMediaArray = [NSMutableArray array];
        for (LLImagePickerModel *picker in list) {
            [selectedMediaArray addObject:picker.image];
        }
        self.selectedImagesArray = selectedMediaArray;
    }];
    
    [self.pickerView observeViewHeight:^(CGFloat height) {
        @strongify(self)
        self.imageVHeight.constant = height;
        [self.view layoutSubviews];
    }];
}

- (IBAction)typeBtnOnclicked:(UIButton *)sender {
    [self.btn0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btn0 setBackgroundColor:[UIColor whiteColor]];
    [self.btn1 setBackgroundColor:[UIColor whiteColor]];
    [self.btn2 setBackgroundColor:[UIColor whiteColor]];
    ViewBorderRadius(_btn0, 2.0f, 0.7, UIColor.lightGrayColor);
    ViewBorderRadius(_btn1, 2.0f, 0.7, UIColor.lightGrayColor);
    ViewBorderRadius(_btn2, 2.0f, 0.7, UIColor.lightGrayColor);
    
    if ([sender isEqual:self.btn0]) {
        [self.btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn0 setBackgroundColor:NAppThemeColor];
        ViewBorderRadius(_btn0, 2.0f, 0.7, NAppThemeColor);
        self.selectedBtnIndex = @"0";
        
    } else if ([sender isEqual:self.btn1]) {
        [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn1 setBackgroundColor:NAppThemeColor];
        ViewBorderRadius(_btn1, 2.0f, 0.7, NAppThemeColor);
        self.selectedBtnIndex = @"1";
        
    } else {
        [self.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn2 setBackgroundColor:NAppThemeColor];
        ViewBorderRadius(_btn2, 2.0f, 0.7, NAppThemeColor);
        self.selectedBtnIndex = @"2";
    }
}

- (IBAction)commitBtnOnclicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender.layer];
    
    if ([self.selectedBtnIndex isEqualToString:@"-1"]) {
        [NYSTools showToast:NLocalizedStr(@"TipsFeedbackType")];
        return;
    }
    
    if (![self.contentTV.text isNotBlank]) {
        [NYSTools showToast:NLocalizedStr(@"TipsFeedbackContent")];
        return;
    }
    
    if (self.selectedImagesArray.count == 0) {
        [NYSTools showToast:NLocalizedStr(@"TipsImg")];
        return;
    }
    
    [self uploadImages:self.selectedImagesArray];
}

/// 上传图片
/// - Parameter images: 图片数组
- (void)uploadImages:(NSArray<UIImage *> *) images {
    [self.selectedImagesUrlArray removeAllObjects];
    
    @weakify(self)
    for (UIImage *image in images) {
        [NYSNetRequest uploadImagesWithType:POST
                                        url:@"/index/Index/upload"
                                   argument:nil
                                       name:@"file"
                                     files:@[image]
                                  fileNames:nil
                                 imageScale:0.5
                                  imageType:nil
                                     remark:@"图像上传"
                                   progress:^(NSProgress * _Nonnull process) {
            
        } success:^(NSDictionary * _Nullable response) {
            @strongify(self)
            [self.selectedImagesUrlArray addObject:[response stringValueForKey:@"src" default:@""]];
            
            if ([image isEqual:[images lastObject]]) {
                [self commit];
            }
        } failed:^(NSError * _Nullable error) {
            
        }];
    }
}

- (void)commit {
    NSMutableDictionary *params = @{
        @"details": _contentTV.text,
        @"type": _selectedBtnIndex,
        @"images": [self.selectedImagesUrlArray componentsJoinedByString:@","]
      }.mutableCopy;
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Feedback/index"
                                      argument:params
                                             remark:@"意见反馈"
                                            success:^(id response) {
        
        @strongify(self)
        [NYSTools showIconToast:NLocalizedStr(@"Commited") isSuccess:YES offset:UIOffsetMake(0, 0)];
        [NYSTools dismissWithDelay:1.0f completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];

    } failed:^(NSError * _Nullable error) {


    }];
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        _placeHolderLabel.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4f];
        _placeHolderLabel.text = NLocalizedStr(@"Tease");
        _placeHolderLabel.font = _contentTV.font;
        [_placeHolderLabel sizeToFit];
    }
    return _placeHolderLabel;
}

- (NSMutableArray<UIImage *> *)selectedImagesArray {
    if (!_selectedImagesArray) {
        _selectedImagesArray = [NSMutableArray array];
    }
    return _selectedImagesArray;
}

- (NSMutableArray<NSString *> *)selectedImagesUrlArray {
    if (!_selectedImagesUrlArray) {
        _selectedImagesUrlArray = [NSMutableArray array];
    }
    return _selectedImagesUrlArray;
}

- (LLImagePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 400) CountOfRow:3];
        _pickerView.type = LLImageTypePhotoAndCamera;
        _pickerView.maxImageSelected = 9;
        _pickerView.allowPickingVideo = NO;
    }
    return _pickerView;
}

@end
