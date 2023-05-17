//
//  NYSWordCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/17.
//

#import "NYSWordCell.h"

@interface NYSWordCell ()
@property (weak, nonatomic) IBOutlet UIView *leftV;
@property (weak, nonatomic) IBOutlet UIView *rightV;
@property (weak, nonatomic) IBOutlet UILabel *leftL0;
@property (weak, nonatomic) IBOutlet UILabel *leftL1;
@property (weak, nonatomic) IBOutlet UILabel *rightL0;
@property (weak, nonatomic) IBOutlet UILabel *rightL1;

@end

@implementation NYSWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewBorderRadius(self.leftV, 0, 0.5, UIColor.whiteColor)
    ViewBorderRadius(self.rightV, 0, 0.5, UIColor.whiteColor)
}

- (void)setModel:(NYSCatalogModel *)model {
    _model = model;
    
    self.leftL0.text = model.content;
    self.leftL1.text = model.translate;
    
    self.rightL0.text = model.content;
    self.rightL1.text = model.translate;
}

@end
