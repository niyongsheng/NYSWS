//
//  NYSMessageCenterCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSMessageCenterCell.h"

@interface NYSMessageCenterCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;

@end

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

- (void)setModel:(NYSMessageCenterModel *)model {
    _model = model;
    
    self.titleL.text = model.title;
    self.subtitleL.text = [NYSTools transformTimestampToTime:model.createtime * 1000 format:nil];
}

@end
