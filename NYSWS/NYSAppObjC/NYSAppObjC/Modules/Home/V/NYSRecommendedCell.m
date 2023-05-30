//
//  NYSRecommendedCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/4.
//

#import "NYSRecommendedCell.h"

@interface NYSRecommendedCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;

@end

@implementation NYSRecommendedCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[self className] owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.getBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleL.adjustsFontSizeToFitWidth = YES;
    self.subtitleL.adjustsFontSizeToFitWidth = YES;
    self.contentView.backgroundColor = UIColor.whiteColor;
    ViewRadius(self.contentView, 10);
    ViewRadius(self.iconIV, 10);
    ViewRadius(self.getBtn, 15);
}

- (void)setModel:(NYSHomeCourseModel *)model {
    _model = model;
    
    [self.iconIV setImageWithURL:NCDNURL(model.image) placeholder:NPImageFillet];
    self.titleL.text = model.name;
    self.subtitleL.text = model.subtitle;
    self.priceL.text = model.price;
    [_getBtn setTitle:NLocalizedStr(@"ActivationExchange") forState:UIControlStateNormal];
    
    if (!model.is_try.boolValue) {
        [_getBtn setTitle:NLocalizedStr(@"ImmediateAudition") forState:UIControlStateNormal];
    }
    
    if (!model.is_course.boolValue) {
        [_getBtn setTitle:NLocalizedStr(@"PurchasedCourse") forState:UIControlStateNormal];
    }
    
    if (!model.is_activation.boolValue) {
        [_getBtn setTitle:NLocalizedStr(@"Activated") forState:UIControlStateNormal];
    }
}


@end
