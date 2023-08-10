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

@property (strong, nonatomic) NYSCustomLabel *leftContentL;
@property (strong, nonatomic) NYSCustomLabel *leftTranslateL;
@property (strong, nonatomic) NYSCustomLabel *rightContentL;
@property (strong, nonatomic) NYSCustomLabel *rightTranslateL;

@end

@implementation NYSWordCell

- (NYSCustomLabel *)leftContentL {
    if (!_leftContentL) {
        _leftContentL = [[NYSCustomLabel alloc] initWithFrame:CGRectMake(10, 5, WordLabelWidth, 20)];
        _leftContentL.adjustsFontSizeToFitWidth = YES;
        _leftContentL.textColor = UIColor.whiteColor;
        _leftContentL.font = WordLabelFont;
        _leftContentL.numberOfLines = 0;
    }
    return _leftContentL;
}

- (NYSCustomLabel *)leftTranslateL {
    if (!_leftTranslateL) {
        _leftTranslateL = [[NYSCustomLabel alloc] initWithFrame:CGRectMake(10, 30, WordLabelWidth, 20)];
        _leftTranslateL.adjustsFontSizeToFitWidth = YES;
        _leftTranslateL.textColor = UIColor.whiteColor;
        _leftTranslateL.font = WordLabelFont;
        _leftTranslateL.numberOfLines = 0;
    }
    return _leftTranslateL;
}

- (NYSCustomLabel *)rightContentL {
    if (!_rightContentL) {
        _rightContentL = [[NYSCustomLabel alloc] initWithFrame:CGRectMake(10, 5, WordLabelWidth, 20)];
        _rightContentL.adjustsFontSizeToFitWidth = YES;
        _rightContentL.textColor = UIColor.whiteColor;
        _rightContentL.font = WordLabelFont;
        _rightContentL.numberOfLines = 0;
    }
    return _rightContentL;
}

- (NYSCustomLabel *)rightTranslateL {
    if (!_rightTranslateL) {
        _rightTranslateL = [[NYSCustomLabel alloc] initWithFrame:CGRectMake(10, 30, WordLabelWidth, 20)];
        _rightTranslateL.adjustsFontSizeToFitWidth = YES;
        _rightTranslateL.textColor = UIColor.whiteColor;
        _rightTranslateL.font = WordLabelFont;
        _rightTranslateL.numberOfLines = 0;
    }
    return _rightTranslateL;
}

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
    
    [self.leftV addSubview:self.leftContentL];
    [self.leftV addSubview:self.leftTranslateL];
    [self.rightV addSubview:self.rightContentL];
    [self.rightV addSubview:self.rightTranslateL];
}

- (void)setModelArr:(NSArray<NYSCatalogModel *> *)modelArr {
    _modelArr = modelArr;
    
    self.leftContentL.text = [[modelArr firstObject] content];
    self.leftTranslateL.text = [[modelArr firstObject] translate];
    
    self.leftContentL.height = [[[modelArr firstObject] content] heightForFont:WordLabelFont width:WordLabelWidth];
    self.leftTranslateL.height = [[[modelArr firstObject] translate] heightForFont:WordLabelFont width:WordLabelWidth];
    self.leftTranslateL.top = self.leftContentL.bottom + 5;
    
    if (modelArr.count > 1) {
        self.rightContentL.text = [[modelArr lastObject] content];
        self.rightTranslateL.text = [[modelArr lastObject] translate];
        
        self.rightContentL.height = [[[modelArr lastObject] content] heightForFont:WordLabelFont width:WordLabelWidth];
        self.rightTranslateL.height = [[[modelArr lastObject] translate] heightForFont:WordLabelFont width:WordLabelWidth];
        self.rightTranslateL.top = self.rightContentL.bottom + 5;
    } else {
        self.rightContentL.text = nil;
        self.rightTranslateL.text = nil;
    }
}

@end
