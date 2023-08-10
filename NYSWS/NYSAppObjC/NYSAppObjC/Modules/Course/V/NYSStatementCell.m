//
//  NYSStatementCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/17.
//

#import "NYSStatementCell.h"

@interface NYSStatementCell ()
@property (weak, nonatomic) IBOutlet UIView *bgV;
@property (strong, nonatomic) NYSCustomLabel *contentL;
@property (strong, nonatomic) NYSCustomLabel *translateL;

@end
@implementation NYSStatementCell

- (NYSCustomLabel *)contentL {
    if (!_contentL) {
        _contentL = [[NYSCustomLabel alloc] initWithFrame:CGRectMake(10, 5, StatementLabelWidth, 20)];
        _contentL.adjustsFontSizeToFitWidth = YES;
        _contentL.textColor = UIColor.whiteColor;
        _contentL.font = StatementLabelFont;
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

- (NYSCustomLabel *)translateL {
    if (!_translateL) {
        _translateL = [[NYSCustomLabel alloc] initWithFrame:CGRectMake(10, 30, StatementLabelWidth, 20)];
        _translateL.adjustsFontSizeToFitWidth = YES;
        _translateL.textColor = UIColor.whiteColor;
        _translateL.font = StatementLabelFont;
        _translateL.numberOfLines = 0;
    }
    return _translateL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewBorderRadius(self.bgV, 0, 0.5, UIColor.whiteColor)
                     
    [self.bgV addSubview:self.contentL];
    [self.bgV addSubview:self.translateL];
}

- (void)setModel:(NYSCatalogModel *)model {
    _model = model;
    
    self.contentL.text = model.content;
    self.translateL.text = model.translate;
    self.contentL.height = [model.content heightForFont:StatementLabelFont width:StatementLabelWidth];
    self.translateL.height = [model.translate heightForFont:StatementLabelFont width:StatementLabelWidth];
    self.translateL.top = self.contentL.bottom + 5;
}

@end
