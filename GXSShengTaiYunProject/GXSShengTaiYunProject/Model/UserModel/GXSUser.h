//
//  GXSUser.h
//  TeamAlbum
//
//  Created by Vicent on 2020/8/27.
//  用户信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXSUser : NSObject
/**询问是否登录*/
@property (nonatomic, readonly, getter=isLogin) BOOL login;
/**用户token*/
@property (nonatomic, readonly, copy) NSString *token;
/**用户id*/
@property (nonatomic, copy) NSString *uid;
/**昵称*/
@property (nonatomic, copy) NSString *nick;
/**头像*/
@property (nonatomic, copy) NSString *heading;
/**性别*/
@property (nonatomic) NSInteger sex;
/**是否VIP*/
@property (nonatomic, getter=isVip) BOOL vip;
/**手机号码*/
@property (nonatomic, copy) NSString *mobile;
/**小程序码*/
@property (nonatomic, copy) NSString *miniprogramcode_url;
/**VIP到期时间*/
@property (nonatomic, copy) NSString *expirationTime;
/**微信号<仅为了保存信息>*/
@property (nonatomic, copy) NSString *wechat_number;
/**微信二维码<仅为了保存信息>*/
@property (nonatomic, copy) NSString *wechat_qrcode;
/**签名<仅为了保存信息>*/
@property (nonatomic, copy) NSString *signature;

/**
 用户信息实例化入口
 @return 用户信息唯一实例
 */
+ (GXSUser *)shareInfo;

/**
 更新用户信息/使用指定用户信息登录<默认缓存至本地>
 @param userInfo 用户信息 null 则删除
 */
- (void)updateUserInfo:(NSDictionary *_Nullable)userInfo;

/**
 更新用户信息/使用指定用户信息登录
 @param userInfo 用户信息 null 则删除
 @param writeToFile 是否缓存至本地
 */
- (void)updateUserInfo:(NSDictionary *_Nullable)userInfo writeToFile:(BOOL)writeToFile;

/**
 登出使用 删除用户信息
 */
- (void)cleanUserInfo;

/**
 请求更新用户信息
 @param completion 完成回调
 */
+ (void)updateUserInfo:(void(^_Nullable)(BOOL isSuccess, NSString *errorMsg))completion;

/**
 同步本地用户信息
 @return 是否同步成功
 */
- (BOOL)synchronize;

/**
 返回一个基于用户uid的文件路径
 @return 文件路径
*/
- (NSString *)fileNameWithExtension:(NSString *)extension;

@end

NS_ASSUME_NONNULL_END
