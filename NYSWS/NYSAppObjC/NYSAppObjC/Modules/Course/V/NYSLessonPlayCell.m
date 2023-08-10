//
//  NYSLessonCell.m
//  LKBusinessCollege
//
//  Created by niyongsheng.github.io on 2022/7/29.
//  Copyright © 2022 NYS. ALL rights reserved.
//

#import "NYSLessonPlayCell.h"

@interface NYSLessonPlayCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@end

@implementation NYSLessonPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(_conView, 10);
}

- (void)setModel:(NYSChapter *)model {
    _model = model;
    
    _titleL.text = model.title;
    _subtitle.text = model.subtitle;
    
    if (model.is_try.boolValue || self.isActived) {
        [_rightIcon setImage:[UIImage imageNamed:@"detail_small_icon"]];
    } else {
        [_rightIcon setImage:[UIImage imageNamed:@"detail_small_hear_icon"]];
    }
    
    if (model.is_try.boolValue && !self.isActived) {
        [_rightIcon setImage:[UIImage imageNamed:@"lock_icon"]];
    }
//    _icon.image = cellModel.isPlaying ? [UIImage imageNamed:@"pause_small_icon"] : [UIImage imageNamed:@"play_small_icon"];
}

@end
