//
//  NYSCatalogSearchViewController.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSCatalogSearchViewController : NYSBaseViewController
/// 是否为首页搜索
@property (assign, nonatomic) BOOL isHomeSearch;
@property (strong, nonatomic) NSArray<NYSChapter *> *chapterArray;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger courseId;
@end

NS_ASSUME_NONNULL_END
