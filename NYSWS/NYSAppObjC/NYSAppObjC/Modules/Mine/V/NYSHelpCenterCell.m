//
//  NYSHelpCenterCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/6/15.
//

#import "NYSHelpCenterCell.h"

@interface NYSHelpCenterCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation NYSHelpCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NYSHelpCenterModel *)model {
    _model = model;
    
    self.titleL.text = model.name;
}

@end
