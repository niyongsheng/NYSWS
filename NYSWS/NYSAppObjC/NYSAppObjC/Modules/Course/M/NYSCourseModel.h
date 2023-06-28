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

@interface NYSCatalogModel : NYSBaseObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , copy) NSString              * translate;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * chapter;
@property (nonatomic , copy) NSString              * content_type;
@property (nonatomic , copy) NSString              * content_url;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * word_list;
@property (nonatomic , copy) NSString              * chapter_id;
@property (nonatomic , copy) NSString              * updatetime;
@property (nonatomic , copy) NSString              * total_page;
@property (nonatomic , copy) NSString              * content;

#pragma mark - 转成base64缓存
@property (nonatomic , copy) NSString              * content_url_base64;
@property (nonatomic , copy) NSString              * url_base64;

@property (nonatomic , copy) NSString              * content_url_path;
@property (nonatomic , copy) NSString              * url_path;

#pragma mark - 首页搜索ADD
/// 当前用户是否已激活0是1否
@property (nonatomic , assign) NSInteger is_activation;
/// 是否有试听章节0是1否
@property (nonatomic , assign) NSInteger is_try;
@end
