//
//  NYSCourseDetailHeader.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSCourseDetailHeader : NYSBaseView
@property (strong, nonatomic) NYSHomeCourseModel *model;
@property (assign, nonatomic) BOOL isHiddenPrice;

@end

NS_ASSUME_NONNULL_END
