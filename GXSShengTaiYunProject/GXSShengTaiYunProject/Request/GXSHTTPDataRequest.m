//
//  GXSHTTPDataRequest.m
//  TeamAlbum
//
//  Created by Vicent on 2020/8/27.
//

#import "GXSHTTPDataRequest.h"
#import "GXSConfiguration.h"
#import <AdSupport/AdSupport.h>
#import "UIDevice+MNHelper.h"
#import "GXSUser.h"
//#import "FLAccessTokenRequest.h"

@implementation GXSHTTPDataRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        self.pagingEnabled = NO;
        self.timeoutInterval = 10.f;
        self.method = MNURLHTTPMethodGet;
        self.cachePolicy = MNURLDataCachePolicyNever;
    }
    return self;
}

#pragma mark - 拼接参数
- (void)handQuery {
    [super handQuery];
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:self.query ? : @{}];
    if (GXSUser.shareInfo.isLogin && ![query objectForKey:@"token"]) {
        [query setObject:GXSUser.shareInfo.token forKey:@"token"];
    }
    if (self.pagingEnabled && ![query objectForKey:@"page"]) {
        [query setObject:@(self.page).stringValue forKey:@"page"];
    }
    self.query = query;
}

#pragma mark - 设置Header信息
- (void)handHeaderField {
    [super handHeaderField];
    NSLog(@"====ACCESS_TOKEN:%@====", ACCESS_TOKEN);
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionaryWithCapacity:0];
//    [headerFields setObject:ACCESS_TOKEN forKey:@"access-token"];
//    [headerFields setObject:NSBundle.bundleVersion forKey:@"version"];
//    [headerFields setObject:IOS_VERSION() forKey:@"sys-version"];
//    [headerFields setObject:NSDate.timestamps forKey:@"time"];
//    [headerFields setObject:GXSConfiguration.identifier forKey:@"device"];
//    //[headerFields setObject:ZMConfiguration.configuration.language forKey:@"language"];
//    [headerFields setObject:(MN_IS_DEBUG ? @"DEBUG" : @"App Store") forKey:@"channel"];
//    //[headerFields setObject:ZMConfiguration.configuration.reachability.reachabilityStatusString forKey:@"network"];
//    [headerFields setObject:[UIDevice model] forKey:@"model"];
//    if (GXSConfiguration.configuration.isAllowsTracking) {
//        [headerFields setObject:ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString forKey:@"idfa"];
//    }
    if (GXSUser.shareInfo.isLogin) {
        [headerFields setObject:[[GXSUser shareInfo] uid] forKey:@"member_id"];
        [headerFields setObject:[[GXSUser shareInfo] token] forKey:@"token"];
        NSLog(@"-------------------当前登录账号-------------------\nuid: %@\ntoken: %@\n", [[GXSUser shareInfo] uid], [[GXSUser shareInfo] token]);
    } else {
        NSLog(@"-------------------当前未登录-------------------");
    }
    self.headerFields = headerFields.copy;
}

#pragma mark - 重定义响应体
- (void)didFinishWithSupposedResponse:(MNURLResponse *)response {
    if (self.serializationType != MNURLSerializationTypeJSON) return;
    NSDictionary *json = response.data;
    response.code = (MNURLResponseCode)[NSDictionary integerValueWithDictionary:json forKey:@"code"];
    NSString *message = [NSDictionary stringValueWithDictionary:json forKey:@"msg"];
    if (message) response.message = message;
    if (response.code == MNURLResponseCodeAccessTokenFailure || [NSDictionary boolValueWithDictionary:json forKey:@"update_token"]) {
        // 刷新AccessToken值
//        [FLAccessTokenRequest requestAccessTokenWithCompletionHandler:^(BOOL succeed) {
//            if (succeed) [GXSConfiguration requestRemoteConfigurationIfNeeded:nil];
//        }];
    }
}

#pragma mark - 更新页码
- (void)didSucceedWithResponseObject:(id)responseObject {
    [super didSucceedWithResponseObject:responseObject];
    if (self.pagingEnabled) {
        BOOL hasMore = [NSDictionary boolValueWithDictionary:responseObject forKey:@"hasMore"];
        self.more = hasMore;
        if (hasMore) self.page ++;
    }
}

@end
