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
@property (nonatomic , copy) NSString              * bannerId;
@property (nonatomic , copy) NSString              * desc;
@property (nonatomic , copy) NSString              * createBy;
@property (nonatomic , copy) NSString              * deptName;
@property (nonatomic , copy) NSString              * bannerType;
@property (nonatomic , copy) NSString              * updateBy;
@property (nonatomic , copy) NSString              * targetUrl;
@property (nonatomic , copy) NSString              * deptId;
@property (nonatomic , copy) NSString              * bannerUrl;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * updateTime;
@end

@interface NYSBusinessModel : NYSBaseObject
@property (nonatomic, strong) NSString * defaultIconName;
@property (nonatomic, strong) NSString * icon_url;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subtitle;
@end

@interface NYSRecommendedModel : NYSBaseObject

@end

@interface NYSCourseModel : NYSBaseObject

@end
