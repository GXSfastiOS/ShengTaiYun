//
//  MNURLResponse.h
//  MNKit
//
//  Created by Vincent on 2018/11/7.
//  Copyright © 2018年 小斯. All rights reserved.
//  请求结果

#import <Foundation/Foundation.h>
@class MNURLRequest;

typedef NS_ENUM(NSInteger, MNURLResponseCode) {
    MNURLResponseCodeUnknown = -1,
    MNURLResponseCodeFailed = 1,
    MNURLResponseCodeSucceed = 0,
    MNURLResponseCodeDataEmpty = 2,
    MNURLResponseCodeTaskError = 3,
    MNURLResponseCodeCancelled = -999,
    MNURLResponseCodeBadURL = -1000,
    MNURLResponseCodeTimeout = -1001,
    MNURLResponseCodeUnsupportedURL = -1002,
    MNURLResponseCodeCannotFindHost = -1003,
    MNURLResponseCodeCannotConnectHost = -1004,
    MNURLResponseCodeNotConnectToInternet = -1009,
    MNURLResponseCodeCannotWriteToFile = -3003,
    MNURLResponseCodeAccessTokenFailure = 103, /// token 失效
    MNURLResponseCodeUserTokenFailure = 201,   /// 用户token失效
    MNURLResponseCodeNeedLogin = 401, ///需要重新登录
    MNURLResponseCodeNeedVIP = 409,///需要充值会员
    MNURLResponseCodePictureCodeError = 102    /// 图片验证码错误
};

NS_ASSUME_NONNULL_BEGIN

@interface MNURLResponse : NSObject<NSCopying>
/**信息*/
@property (nonatomic, copy) NSString *message;
/**响应码*/
@property (nonatomic) MNURLResponseCode code;
/**数据*/
@property (nonatomic, strong, readonly, nullable) id data;
/**原错误信息*/
@property (nonatomic, copy, readonly, nullable) NSError *error;
/**记录此次请求体*/
@property (nonatomic, weak, readonly, nullable) __kindof MNURLRequest *request;

/**
 失败响应体
 @param error 错误
 @return 响应实例
 */
+ (MNURLResponse *)responseWithError:(NSError *)error;

/**
 成功响应体
 @param data 数据
 @return 响应实例
 */
+ (MNURLResponse *)succeedResponseWithData:(id)data;

@end


@interface NSError (MNURLResponseError)

/**请求体实例化失败错误*/
@property (nonatomic, readonly, class) NSError *taskError;

@end

NS_ASSUME_NONNULL_END
