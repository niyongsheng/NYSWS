//
//  NYSPurchasedCourseDetailVC.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSPurchasedCourseDetailVC : NYSBaseViewController
@property (strong, nonatomic) NYSHomeCourseModel *model;

@property (nonatomic, assign) BOOL isOffLine;
@property (strong, nonatomic) NYSHomeCourseModel *detailModel;
@end

NS_ASSUME_NONNULL_END
