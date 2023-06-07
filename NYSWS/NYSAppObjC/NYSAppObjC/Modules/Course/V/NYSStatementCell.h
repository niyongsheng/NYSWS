//
//  NYSStatementCell.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/17.
//

#import <UIKit/UIKit.h>

#define StatementLabelWidth kScreenWidth - 70
#define StatementLabelFont  [UIFont systemFontOfSize:15]

NS_ASSUME_NONNULL_BEGIN

@interface NYSStatementCell : UITableViewCell
@property (nonatomic, weak) NYSCatalogModel *model;
@end

NS_ASSUME_NONNULL_END
