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
    
    // 创建一个后台队列，并发执行多任务
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    // 在后台队列中异步执行任务
    dispatch_async(backgroundQueue, ^{
        NSDictionary *optoins = @{
            NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
            NSFontAttributeName:[UIFont systemFontOfSize:20]
        };
        NSString *contentStr = self.contentStr;
        NSString *handelStr = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important;height:auto}</style></head>%@", NScreenWidth - 30, contentStr];
        NSData *data = [handelStr dataUsingEncoding:NSUnicodeStringEncoding];
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:nil];
        CGSize attSize = [attributeString boundingRectWithSize:CGSizeMake(NScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        // 切换主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentL.attributedText = attributeString;
            self.contentViewHeight.constant = attSize.height;
        });
    });
}

@end
