//
//  NYSCourseDetailHeader.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCourseDetailHeader.h"

@interface NYSCourseDetailHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *versionL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UILabel *sectionL;

@end

@implementation NYSCourseDetailHeader

- (void)setupView {
    
    ViewRadius(self.iconIV, 7);
    self.priceL.adjustsFontSizeToFitWidth = YES;
    self.timeL.adjustsFontSizeToFitWidth = YES;
    self.versionL.adjustsFontSizeToFitWidth = YES;
}

- (void)setModel:(NYSHomeCourseModel *)model {
    _model = model;
    
    [self.iconIV setImageWithURL:[NSURL URLWithString:model.image] placeholder:NPImageFillet];
    self.titleL.text = model.name;
    self.subtitleL.text = model.name;
    
    NSDictionary *optoins = @{
        NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
        NSFontAttributeName:[UIFont systemFontOfSize:17]
    };
    NSString *contentStr = model.details;
    NSString *handelStr = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;height:auto}</style></head>%@", NScreenWidth - 30, contentStr];
    NSData *data = [handelStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:nil];
    self.descL.attributedText = attributeString;

    self.priceL.text = model.price;
    self.timeL.text = [NSString stringWithFormat:@"%@：%@", NLocalizedStr(@"UpdateTime"), [NYSTools transformTimestampToTime:model.updatetime * 1000 format:nil]];
    self.versionL.text = [NSString stringWithFormat:@"%@：%.2fMB   %@：%@",
                          NLocalizedStr(@"CourseSize"), model.size, NLocalizedStr(@"CourseVersion"), model.version];
    self.sectionL.text = [NSString stringWithFormat:@"%@%ld%@", NLocalizedStr(@"Total"), model.chapter.count, NLocalizedStr(@"Section")];
}

@end
