//
//  NYSMyCourseCell.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSMyCourseCell.h"

@interface NYSMyCourseCell ()
@property (weak, nonatomic) IBOutlet UIView *bgV;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIImageView *tagIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *versionL;
@end

@implementation NYSMyCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    ViewRadius(self.bgV, 10);
    ViewRadius(self.iconIV, 7);
    self.timeL.adjustsFontSizeToFitWidth = YES;
    self.versionL.adjustsFontSizeToFitWidth = YES;
    self.subtitleL.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NYSHomeCourseModel *)model {
    _model = model;
    
    [self.iconIV setImageWithURL:NCDNURL(model.image) placeholder:NPImageFillet];
    self.titleL.text = model.name;
    self.subtitleL.text = model.subtitle;
    
    self.timeL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"UpdateTime"), [NYSTools transformTimestampToTime:model.updatetime * 1000 format:nil]];
    self.versionL.text = [NSString stringWithFormat:@"%@：%.2fMB   %@：%@",
                          NLocalizedStr(@"CourseSize"), model.size, NLocalizedStr(@"CourseVersion"), model.version];
    self.tagIV.hidden = [model.is_recommend isEqual:@"1"] ? YES : NO;
}

@end
