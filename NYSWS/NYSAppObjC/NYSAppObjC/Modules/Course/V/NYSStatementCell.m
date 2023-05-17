//
//  NYSStatementCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/17.
//

#import "NYSStatementCell.h"

@interface NYSStatementCell ()
@property (weak, nonatomic) IBOutlet UIView *bgV;
@property (weak, nonatomic) IBOutlet UILabel *statementL0;
@property (weak, nonatomic) IBOutlet UILabel *statementL1;

@end
@implementation NYSStatementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewBorderRadius(self.bgV, 0, 0.5, UIColor.whiteColor)
}

- (void)setModel:(NYSCatalogModel *)model {
    _model = model;
    
    self.statementL0.text = model.content;
    self.statementL1.text = model.translate;
}

@end
