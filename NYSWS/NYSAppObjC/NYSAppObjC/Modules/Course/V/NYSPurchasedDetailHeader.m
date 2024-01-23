//
//  NYSCourseDetailHeader.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSPurchasedDetailHeader.h"

@interface NYSPurchasedDetailHeader ()
@property (strong, nonatomic) YYLabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *sizeL;
@property (weak, nonatomic) IBOutlet UILabel *versionL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UILabel *sectionL;
@end

@implementation NYSPurchasedDetailHeader

- (void)setupView {
    ViewRadius(self.topView, 30);
    
    self.label = [YYLabel new];
    self.label.numberOfLines = 0;
    self.label.userInteractionEnabled = YES;
    [self.label addGestureRecognizer];
    [self.descL addSubview:self.label];
    
    self.descL.userInteractionEnabled = YES;
    self.descL.text = nil;
}

- (void)setModel:(NYSHomeCourseModel *)model {
    _model = model;
    
    NSMutableAttributedString *aStr = [NYSCustomLabel getAttributedString:model.details];
    CGRect frame = [NYSCustomLabel getAttributedStringFrame:aStr width:kScreenWidth - 30];
    if (aStr != nil) self.label.attributedText = aStr;
    self.label.frame = frame;
    self.descLHeight.constant = frame.size.height;
    
    self.timeL.text = [NYSTools transformTimestampToTime:model.updatetime * 1000 format:nil];
    self.sizeL.text = [NSString stringWithFormat:@"%.2f", model.size];
    self.versionL.text = model.version;
    self.sectionL.text = [NSString stringWithFormat:@"%@%ld%@", NLocalizedStr(@"Total"), model.chapter.count, NLocalizedStr(@"Section")];
}

@end
