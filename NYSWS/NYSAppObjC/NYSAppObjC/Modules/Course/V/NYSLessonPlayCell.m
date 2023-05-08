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

@end

@implementation NYSLessonPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(_conView, 10);
}

//- (void)setCellModel:(NYSItemListModel *)cellModel {
//    _cellModel = cellModel;
//    
//    _titleL.text = cellModel.itemTitle;
//    _subtitle.text = [NSString stringWithFormat:@"%ld次学习", cellModel.itemLearnCount];
//    _icon.image = cellModel.isPlaying ? [UIImage imageNamed:@"pause_small_icon"] : [UIImage imageNamed:@"play_small_icon"];
//}

@end
