//
//  NYSLessonCell.h
//  LKBusinessCollege
//
//  Created by niyongsheng.github.io on 2022/7/29.
//  Copyright © 2022 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSLessonPlayCell : UITableViewCell
/// 是否已激活
@property (nonatomic, assign) BOOL isActived;
@property (nonatomic, weak) NYSChapter *model;
@end

NS_ASSUME_NONNULL_END
