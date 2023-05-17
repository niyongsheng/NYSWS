//
//  NYSCatalogViewController.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSCatalogSearchViewController : NYSBaseViewController
@property (strong, nonatomic) NSArray<NYSChapter *> *chapterArray;
@property (assign, nonatomic) NSInteger index;
@end

NS_ASSUME_NONNULL_END
