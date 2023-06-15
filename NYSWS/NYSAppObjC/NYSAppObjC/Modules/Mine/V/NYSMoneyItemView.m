//
//  NYSMoneyItemView.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/4.
//

#import "NYSMoneyItemView.h"

@interface NYSMoneyItemView ()
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;

@end

@implementation NYSMoneyItemView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentV.userInteractionEnabled = YES;
    
    @weakify(self)
    [self.contentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        if ([self.delegate conformsToProtocol:@protocol(NYSMoneyItemViewDelegate)] && [self.delegate respondsToSelector:@selector(moneyItemViewOnclicked:)]) {
            [self.delegate moneyItemViewOnclicked:self.index];
        }
    }]];
}

- (void)setModel:(NYSMoneyItemModel *)model {
    _model = model;
    
    self.titleL.text = model.money;
    self.subtitleL
        .text = model.money;
}

@end
