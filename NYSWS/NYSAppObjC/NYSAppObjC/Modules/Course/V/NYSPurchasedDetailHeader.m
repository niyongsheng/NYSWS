//
//  NYSCourseDetailHeader.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSPurchasedDetailHeader.h"

@interface NYSPurchasedDetailHeader ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *sizeL;
@property (weak, nonatomic) IBOutlet UILabel *versionL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UILabel *sectionL;
@end

@implementation NYSPurchasedDetailHeader

- (void)setupView {
    ViewRadius(self.topView, 30);
}

- (void)setModel:(NYSHomeCourseModel *)model {
    _model = model;
        
    NSDictionary *optoins = @{
        NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
        NSFontAttributeName:[UIFont systemFontOfSize:17]
    };
    NSString *contentStr = model.details;
    NSString *handelStr = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;height:auto}</style></head>%@", NScreenWidth - 30, contentStr];
    NSData *data = [handelStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:nil];
    self.descL.attributedText = attributeString;

    self.timeL.text = [NYSTools transformTimestampToTime:model.updatetime * 1000 format:nil];
    self.sizeL.text = [NSString stringWithFormat:@"%.2f", model.size];
    self.versionL.text = model.version;
    self.sectionL.text = [NSString stringWithFormat:@"%@%ld%@", NLocalizedStr(@"Total"), model.chapter.count, NLocalizedStr(@"Section")];
}

@end
