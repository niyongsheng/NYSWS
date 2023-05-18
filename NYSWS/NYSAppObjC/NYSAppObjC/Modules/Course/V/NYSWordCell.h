//
//  NYSWordCell.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NYSWordCellBlock)(BOOL isLeft, NSIndexPath *indexP);

@interface NYSWordCell : UITableViewCell
@property (nonatomic, copy) NYSWordCellBlock block;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, weak) NSArray<NYSCatalogModel *> *modelArr;
@property (nonatomic, weak) NYSCatalogModel *model;
@end

NS_ASSUME_NONNULL_END
