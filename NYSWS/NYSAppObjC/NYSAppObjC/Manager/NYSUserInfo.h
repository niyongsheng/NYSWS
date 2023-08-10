//
//  NYSUserInfo.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <NYSUIKit/NYSUIKit.h>

/// 用户信息模型
@interface NYSUserInfo : NYSBaseObject
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * update_time;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * invitation_code;
@property (nonatomic , copy) NSString              * create_time;
@property (nonatomic , copy) NSString              * security_answer;
@property (nonatomic , copy) NSString              * security_question;
@property (nonatomic , copy) NSString              * balance;

@property (nonatomic , assign) NSInteger              superior_id;
@property (nonatomic , assign) NSInteger              uid;
@property (nonatomic , assign) NSInteger              cishu;
@property (nonatomic , copy) NSString              * unionid;
@property (nonatomic , copy) NSString              * openid;
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , copy) NSString              * expiretime;
@property (nonatomic , copy) NSString              * password;
@property (nonatomic , copy) NSString              * invite_code;
@end

/// 授权信息模型
@interface NYSAuthInfo : NYSBaseObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * code;
/// 令牌
@property (nonatomic , copy) NSString              * token;
/// 失效时间
@property (nonatomic , copy) NSString              * expirationTime;
@property (nonatomic , assign) BOOL              status;
@end
