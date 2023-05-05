//
//  NYSCourseCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/4.
//

#import "NYSCourseCell.h"

@interface NYSCourseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@end

@implementation NYSCourseCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[self className] owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = UIColor.whiteColor;
    ViewRadius(self.contentView, 7);
    ViewRadius(self.iconIV, 5);
    ViewRadius(self.getBtn, 15);
}

@end
