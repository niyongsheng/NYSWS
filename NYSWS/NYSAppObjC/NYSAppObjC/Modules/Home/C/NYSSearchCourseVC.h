//
//  NYSSearchVC.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/4.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSSearchCourseVC : NYSBaseViewController
/// 课程分类
@property (nonatomic, strong) NSString *classId;
/// 类型： 0 首页搜索；2课程分类；3分类搜索；
@property (nonatomic, strong) NSString *type;
@end

NS_ASSUME_NONNULL_END
