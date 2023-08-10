//
//  NYSCacheViewController.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSCacheViewController : NYSBaseViewController
@property (strong, nonatomic) NSArray<NYSChapter *> *chapterArray;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger courseId;
@property (assign, nonatomic) BOOL isFromTry;

/// 传递广告胶囊
@property (strong, nonatomic) NYSHomeCourseModel *courseModel;

@end

NS_ASSUME_NONNULL_END
