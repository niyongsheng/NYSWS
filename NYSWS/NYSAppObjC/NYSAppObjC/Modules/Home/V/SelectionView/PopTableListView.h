//
//  PopTableListView.h
//  PopView
//
//  Created by 李林 on 2018/2/28.
//  Copyright © 2018年 李林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopTableCellDelegate <NSObject>
- (void)cellOnclick:(NSIndexPath *)indexPath tag:(NSInteger)tag;
@end

@interface PopTableListView : UIView
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles imgNames:(NSArray <NSString *>*)imgNames;
@property (nonatomic, assign) NSInteger viewTag;

@property (weak, nonatomic) id<PopTableCellDelegate> delegate;
@end
