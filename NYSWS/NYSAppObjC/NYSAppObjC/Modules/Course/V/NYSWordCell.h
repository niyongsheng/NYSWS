//
//  NYSWordCell.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/17.
//

#import <UIKit/UIKit.h>

#define WordLabelWidth (kScreenWidth - 90)/2
#define WordLabelFont  [UIFont systemFontOfSize:15]

NS_ASSUME_NONNULL_BEGIN

typedef void(^NYSWordCellBlock)(BOOL isLeft, NSIndexPath *indexP);

@interface NYSWordCell : UITableViewCell
@property (nonatomic, copy) NYSWordCellBlock block;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, weak) NSArray<NYSCatalogModel *> *modelArr;
@end

NS_ASSUME_NONNULL_END
