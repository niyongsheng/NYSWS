//
//  NYSRecommendedCell.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/4.
//

#import <UIKit/UIKit.h>

@class NYSHomeCourseModel;

@interface NYSRecommendedCell : UICollectionViewCell
@property (nonatomic, weak) NYSHomeCourseModel *model;

@end

