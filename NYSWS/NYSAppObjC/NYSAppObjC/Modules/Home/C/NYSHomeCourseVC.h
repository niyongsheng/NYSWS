//
//  NYSHomeCourseVC.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NYSHomeCourseVCDelegate <NSObject>

- (void)tableviewHeight:(CGFloat)height;

@end

@interface NYSHomeCourseVC : NYSBaseViewController
@property (nonatomic, strong) NSString *index;
@property (nonatomic, assign) CGFloat tableViewHeight;

@property (nonatomic, weak) id<NYSHomeCourseVCDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
