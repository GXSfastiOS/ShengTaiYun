//
//  GXSConfiguration.h
//  TeamAlbum
//
//  Created by Vicent on 2020/8/27.
//  配置信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXSConfiguration : NSObject
/**域名*/
@property (nonatomic, copy) NSString *baseacturl;
/**唯一标识*/
@property (nonatomic, copy, readonly, class) NSString *identifier;
/**token值*/
@property (nonatomic, copy) NSString *access_token;
/**判断是否可用<表示通过SH>*/
@property (nonatomic, readonly, getter=isEnabled) BOOL enabled;
/**语言*/
@property (nonatomic, copy) NSString *language;
/**是否允许广告追踪*/
@property (nonatomic, getter=isAllowsTracking) BOOL allowsTracking;
/**需要跳转详情的产品ID*/
@property (nonatomic, copy, nullable) NSString *product;


/**
 配置信息实例化入口
 @return 配置信息唯一实例
 */
+ (GXSConfiguration *)configuration;

/**Swift入口*/
+ (GXSConfiguration *)shareInstance;

/**
 拼接地址
 @param url 地址
 @return 链接地址
 */
- (NSString *)handUrl:(NSString *)url;

/**
 请求配置信息
 @param completionHandler 完成回调
 */
+ (void)requestRemoteConfigurationIfNeeded:(void (^_Nullable)(BOOL))completionHandler;

/**
 请求配置信息
 @param completionHandler 完成回调
 */
+ (void)requestRemoteConfigurationWithCompletionHandler:(void (^_Nullable)(BOOL))completionHandler;

@end

NS_ASSUME_NONNULL_END
