//
//  NYSCourseModel.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import <NYSUIKit/NYSUIKit.h>

@interface NYSCourseModel : NYSBaseObject

@end

@interface NYSMovementModel : NYSBaseObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) float              before_balance;
@property (nonatomic , assign) NSInteger              updatetime;
@property (nonatomic , copy) NSString              * notes;
@property (nonatomic , copy) NSString              * order_id;
@property (nonatomic , assign) float              after_balance;
@property (nonatomic , assign) NSInteger              user_id;
@property (nonatomic , assign) float              change_balance;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , assign) NSInteger              createtime;
@property (nonatomic , copy) NSString              * type_text;
@end
