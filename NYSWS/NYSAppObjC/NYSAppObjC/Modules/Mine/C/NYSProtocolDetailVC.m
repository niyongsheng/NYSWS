//
//  NYSMineViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.

#import "NYSProtocolDetailVC.h"

@interface NYSProtocolDetailVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@end

@implementation NYSProtocolDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *optoins = @{
        NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
        NSFontAttributeName:[UIFont systemFontOfSize:20]
    };
    NSString *contentStr = self.contentStr;
    NSString *handelStr = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;height:auto}</style></head>%@", NScreenWidth - 30, contentStr];
    NSData *data = [handelStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:nil];
    CGSize attSize = [attributeString boundingRectWithSize:CGSizeMake(NScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    self.contentL.attributedText = attributeString;
    self.contentViewHeight.constant = attSize.height;
}

@end
