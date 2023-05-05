//
//  NYSBusinessView.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/4.
//

#import <NYSUIKit/NYSUIKit.h>

@protocol NYSBusinessViewDelegate <NSObject>

- (void)tapViewWithModel:(NYSBusinessModel *)model;

@end

@class NYSBusinessModel;

@interface NYSBusinessView : NYSBaseView
@property (nonatomic, weak) NYSBusinessModel *businessModel;

@property (nonatomic, weak) id<NYSBusinessViewDelegate> delegate;

@end

