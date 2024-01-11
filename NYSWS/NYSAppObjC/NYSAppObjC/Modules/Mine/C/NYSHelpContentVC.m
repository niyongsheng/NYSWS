//
//  NYSHelpContentVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/17.
//

#import "NYSHelpContentVC.h"

@interface NYSHelpContentVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageIVH;

@end

@implementation NYSHelpContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.model.name;
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Index/news_info"
                                       parameters:@{@"id" : @(self.model.ID)}
                                         remark:@"帮助详情"
                                        success:^(id response) {
        @strongify(self)
        NSDictionary *optoins = @{
            NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
            NSFontAttributeName:[UIFont systemFontOfSize:20]
        };
        NSString *contentStr = [response stringValueForKey:@"content" default:@""];
        NSString *handelStr = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;height:auto}</style></head>%@", NScreenWidth - 30, contentStr];
        NSData *data = [handelStr dataUsingEncoding:NSUnicodeStringEncoding];
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:nil];
        CGSize attSize = [attributeString boundingRectWithSize:CGSizeMake(NScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        
        self.contentL.attributedText = attributeString;
        CGFloat imgH = 0;
        if ([response[@"image"] isNotBlank]) {
            imgH = 150;
            [self.imageIV setImageURL:NCDNURL(response[@"image"])];
        }
        self.imageIVH.constant = imgH;
        self.contentViewHeight.constant = attSize.height + 175;

    } failed:^(NSError * _Nullable error) {

    }];
    
}

@end
