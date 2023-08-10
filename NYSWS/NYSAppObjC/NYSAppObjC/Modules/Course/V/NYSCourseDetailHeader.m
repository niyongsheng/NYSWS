//
//  NYSCourseDetailHeader.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCourseDetailHeader.h"

@interface NYSCourseDetailHeader ()
@property (strong, nonatomic) YYLabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *versionL;
@property (weak, nonatomic) IBOutlet UIImageView *coinIV;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UILabel *sectionL;

@end

@implementation NYSCourseDetailHeader

- (void)setupView {
    ViewRadius(self.topView, 30);
    ViewRadius(self.iconIV, 7);
    self.priceL.adjustsFontSizeToFitWidth = YES;
    self.timeL.adjustsFontSizeToFitWidth = YES;
    self.versionL.adjustsFontSizeToFitWidth = YES;
    self.subtitleL.adjustsFontSizeToFitWidth = YES;
    
    self.label = [YYLabel new];
    self.label.numberOfLines = 0;
    self.label.userInteractionEnabled = YES;
    [self.label addGestureRecognizer];
    [self.descL addSubview:self.label];
    
    self.descL.userInteractionEnabled = YES;
    self.descL.text = nil;
}

- (void)setIsHiddenPrice:(BOOL)isHiddenPrice {
    _isHiddenPrice = isHiddenPrice;
    
    self.priceL.hidden = self.isHiddenPrice;
    self.coinIV.hidden = self.isHiddenPrice;
}

- (void)setModel:(NYSHomeCourseModel *)model {
    _model = model;
    
    [self.iconIV setImageWithURL:NCDNURL(model.image) placeholder:NPImageFillet];
    self.titleL.text = model.name;
    self.subtitleL.text = model.subtitle;
    
    NSMutableAttributedString *aStr = [NYSCustomLabel getAttributedString:model.details];
    CGRect frame = [NYSCustomLabel getAttributedStringFrame:aStr width:kScreenWidth - 30];
    self.label.attributedText = aStr;
    self.label.frame = frame;
    self.descLHeight.constant = frame.size.height;

    self.priceL.text = model.price;
    self.timeL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"UpdateTime"), [NYSTools transformTimestampToTime:model.updatetime * 1000 format:nil]];
    self.versionL.text = [NSString stringWithFormat:@"%@：%.2fMB   %@：%@",
                          NLocalizedStr(@"CourseSize"), model.size, NLocalizedStr(@"CourseVersion"), model.version];
    self.sectionL.text = [NSString stringWithFormat:@"%@%ld%@", NLocalizedStr(@"Total"), model.chapter.count, NLocalizedStr(@"Section")];
}

@end
