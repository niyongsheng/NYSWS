//
//  NYSMessageCenterCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSMessageCenterCell.h"

@implementation NYSMessageCenterCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[self className] owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
