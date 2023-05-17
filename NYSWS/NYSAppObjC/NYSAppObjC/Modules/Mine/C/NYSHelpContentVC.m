//
//  NYSHelpContentVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/17.
//

#import "NYSHelpContentVC.h"

@interface NYSHelpContentVC ()
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@end

@implementation NYSHelpContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.index == 0) {
        self.navigationItem.title = @"多久到账";
    } else {
        self.navigationItem.title = @"如何提现";
    }
    
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Member/get_help"
                                       argument:nil
                                         remark:@"提现帮助"
                                        success:^(id response) {
        @strongify(self)
        NSDictionary *optoins = @{
            NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
            NSFontAttributeName:[UIFont systemFontOfSize:17]
        };
        NSString *contentStr = [response[self.index] stringValueForKey:@"value" default:@""];
        NSString *handelStr = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;height:auto}</style></head>%@", NScreenWidth - 30, contentStr];
        NSData *data = [handelStr dataUsingEncoding:NSUnicodeStringEncoding];
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:nil];
        self.contentL.attributedText = attributeString;

    } failed:^(NSError * _Nullable error) {

    }];
    
}

@end
