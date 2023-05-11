//
//  NYSHomeModel.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/4/28.
//

#import <NYSUIKit/NYSUIKit.h>

@interface NYSHomeModel : NYSBaseObject
@end


@interface NYSBannerModel : NYSBaseObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * create_time;
@end

@interface NYSBusinessModel : NYSBaseObject
@property (nonatomic, strong) NSString * defaultIconName;
@property (nonatomic, strong) NSString * icon_url;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subtitle;
@end

@interface NYSRecommendedModel : NYSBaseObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              createtime;
@property (nonatomic , copy) NSString              * version;
@property (nonatomic , copy) NSString              * details;
@property (nonatomic , assign) NSInteger              size;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , assign) NSInteger              updatetime;
@property (nonatomic , assign) NSInteger              class_id;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * is_recommend;
@end

@interface NYSHomeCourseModel : NYSBaseObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              createtime;
@property (nonatomic , copy) NSString              * version;
@property (nonatomic , copy) NSString              * details;
@property (nonatomic , assign) NSInteger              size;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , assign) NSInteger              updatetime;
@property (nonatomic , assign) NSInteger              class_id;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * is_recommend;

@end

@interface NYSMessageCenterModel : NYSBaseObject
@property (nonatomic , copy) NSString              * updatetime;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * user_id;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * createtime;
@end
