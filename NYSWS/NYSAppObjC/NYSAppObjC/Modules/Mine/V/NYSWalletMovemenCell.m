//
//  NYSMessageCenterCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSWalletMovemenCell.h"

@interface NYSWalletMovemenCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *movementL;

@end
@implementation NYSWalletMovemenCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[self className] owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewRadius(self.contentView, 7);
}

- (void)setModel:(NYSMovementModel *)model {
    _model = model;
    
    
}

@end
