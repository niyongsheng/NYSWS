//
//  NYSMessageCenterCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSWalletMovemenCell.h"

@interface NYSWalletMovemenCell ()
@property (weak, nonatomic) IBOutlet UIView *bgV;
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
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    ViewRadius(self.bgV, 10);
}

- (void)setModel:(NYSMovementModel *)model {
    _model = model;
    
    self.titleL.text = model.notes;
    self.timeL.text = [NYSTools transformTimestampToTime:model.createtime * 1000 format:nil];
    self.movementL.text = [NSString stringWithFormat:@"%@%.2f", model.type_text, model.change_balance];
    self.movementL.textColor = [model.type isEqualToString:@"0"] ? [UIColor blackColor] : [UIColor redColor];
}

@end
