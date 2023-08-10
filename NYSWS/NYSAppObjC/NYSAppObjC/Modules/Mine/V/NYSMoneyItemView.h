//
//  NYSMoneyItemView.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/4.
//

#import <NYSUIKit/NYSUIKit.h>

@protocol NYSMoneyItemViewDelegate <NSObject>
/// 金额点击
/// - Parameter index: 索引号
- (void)moneyItemViewOnclicked:(NSInteger)index;

@end

@interface NYSMoneyItemView : NYSBaseView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NYSMoneyItemModel *model;

@property (weak, nonatomic) id<NYSMoneyItemViewDelegate> delegate;
@end

