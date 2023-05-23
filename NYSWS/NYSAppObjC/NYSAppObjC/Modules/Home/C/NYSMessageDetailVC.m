//
//  NYSMineViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.

#import "NYSMessageDetailVC.h"

@interface NYSMessageDetailVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@end

@implementation NYSMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NLocalizedStr(@"Detail");
    
    self.titleL.text = self.model.title;
    self.timeL.text = [NYSTools transformTimestampToTime:self.model.createtime * 1000 format:nil];
    
    NSDictionary *optoins = @{
        NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
        NSFontAttributeName:[UIFont systemFontOfSize:20]
    };
    NSString *contentStr = self.model.content;
    NSString *handelStr = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;height:auto}</style></head>%@", NScreenWidth - 30, contentStr];
    NSData *data = [handelStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:nil];
    CGSize attSize = [attributeString boundingRectWithSize:CGSizeMake(NScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    self.contentL.attributedText = attributeString;
    self.contentViewHeight.constant = attSize.height + 50;
}

@end
