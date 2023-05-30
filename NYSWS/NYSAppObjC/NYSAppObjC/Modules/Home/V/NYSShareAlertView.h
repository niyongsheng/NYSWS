//
//  NYSView.h
//  NYS
//
//  Created by niyongsheng.github.io on 2021/8/9.
//  Copyright © 2021 NYS. ALL rights reserved.
//

#import <NYSUIKit/NYSUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NYSShareAlertBlock)(NSInteger index, id obj);

@interface NYSShareAlertView : NYSBaseView

/// 分享链接
@property (nonatomic, strong) NSString *url;
/// 回调
@property (nonatomic, strong) NYSShareAlertBlock block;

- (void)updateData:(id)data;
@end

NS_ASSUME_NONNULL_END
