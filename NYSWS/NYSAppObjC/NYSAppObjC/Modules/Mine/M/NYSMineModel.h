//
//  NYSMineModel.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSMineModel : NYSBaseObject

@end

@interface NYSHelpCenterModel : NYSBaseObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * create_time;
@end

@interface NYSMoneyItemModel : NYSBaseObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * updatetime;
@property (nonatomic , copy) NSString              * money;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * sort;

@property (nonatomic , copy) NSString              * applePayId;
@end

@interface NYSPayWayModel : NYSBaseObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * config;
@property (nonatomic , copy) NSString              * value;
@end

NS_ASSUME_NONNULL_END
