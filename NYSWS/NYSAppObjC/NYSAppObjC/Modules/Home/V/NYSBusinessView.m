//
//  NYSBusinessView.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/4.
//

#import "NYSBusinessView.h"

@interface NYSBusinessView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation NYSBusinessView

- (void)layoutSubviews {
    
    WS(weakSelf)
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if([weakSelf.delegate respondsToSelector:@selector(tapViewWithModel:)]){
            [weakSelf.delegate tapViewWithModel:weakSelf.businessModel];
        }
    }]];
}

- (void)setBusinessModel:(NYSBusinessModel *)businessModel {
    _businessModel = businessModel;
    
    self.titleL.text = businessModel.title;
    [self.iconIV setImageWithURL:[NSURL URLWithString:businessModel.icon_url] placeholder:[UIImage imageNamed:businessModel.defaultIconName]];
}

@end
