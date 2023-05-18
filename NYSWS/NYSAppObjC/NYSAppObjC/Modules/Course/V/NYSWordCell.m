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
    
    self.leftV.userInteractionEnabled = YES;
    [self.leftV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.block) {
            self.block(YES, self.indexPath);
        }
    }]];
    
    self.rightV.userInteractionEnabled = YES;
    [self.rightV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.block) {
            self.block(NO, self.indexPath);
        }
    }]];
}

- (void)setModel:(NYSCatalogModel *)model {
    _model = model;
    
    self.leftL0.text = model.content;
    self.leftL1.text = model.translate;
    
    self.rightL0.text = model.content;
    self.rightL1.text = model.translate;
}

- (void)setModelArr:(NSArray<NYSCatalogModel *> *)modelArr {
    _modelArr = modelArr;
    
    self.leftL0.text = [[modelArr firstObject] content];
    self.leftL1.text = [[modelArr firstObject] translate];
    
    if (modelArr.count > 1) {
        self.rightL0.text = [[modelArr lastObject] content];
        self.rightL1.text = [[modelArr lastObject] translate];
    } else {
        self.rightL0.text = nil;
        self.rightL1.text = nil;
    }
}

@end
