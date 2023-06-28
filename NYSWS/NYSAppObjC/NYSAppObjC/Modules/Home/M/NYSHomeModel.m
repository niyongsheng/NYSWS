//
//  NYSHomeModel.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/4/28.
//

#import "NYSHomeModel.h"

@implementation NYSHomeModel
@end

@implementation NYSBannerModel
@end

@implementation NYSBusinessModel
@end

@implementation NYSChapterContentModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"word_list" : [NYSCatalogModel class],
        @"statement_list" : [NYSCatalogModel class]
    };
}
@end

@implementation NYSChapter
@end

@implementation NYSHomeCourseModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"chapter" : [NYSChapter class]
    };
}
@end

@implementation NYSMessageCenterModel
@end
