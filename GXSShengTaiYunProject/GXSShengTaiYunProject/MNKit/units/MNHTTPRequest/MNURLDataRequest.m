//
//  MNURLDataRequest.m
//  MNKit
//
//  Created by Vincent on 2018/11/7.
//  Copyright © 2018年 小斯. All rights reserved.
//

#import "MNURLDataRequest.h"

@interface MNURLDataRequest ()

@end

@implementation MNURLDataRequest
- (void)initialized {
    [super initialized];
    self.cacheTimeInterval = 3.f;
    self.method = MNURLHTTPMethodGet; 
    self.dataSource = MNURLDataSourceNetwork;
    self.cachePolicy = MNURLDataCachePolicyNever;
}

- (void)loadData:(MNURLRequestStartCallback)startCallback
            completion:(MNURLRequestFinishCallback)finishCallback
{
    self.startCallback = startCallback;
    self.finishCallback = finishCallback;
    [self resume];
}

#pragma mark - Super
- (void)didFinishWithResponseObject:(id)responseObject error:(NSError *)error {
    MNURLResponse *response;
    if (responseObject) {
        response = [MNURLResponse succeedResponseWithData:responseObject];
        [response setValue:self forKey:MNURLPath(response.request)];
        /**根据项目需求定制自己的状态码*/
        [self didFinishWithSupposedResponse:response];
        if ([self.delegate respondsToSelector:@selector(didFinishRequesting:supposedResponse:)]) {
            [self.delegate didFinishRequesting:self supposedResponse:response];
        }
    } else {
        if (!error) {
            error = [NSError errorWithDomain:NSURLErrorDomain
                                        code:MNURLResponseCodeDataEmpty
                                    userInfo:@{NSLocalizedDescriptionKey:@"请求数据失败",
                                               NSLocalizedFailureReasonErrorKey: @"请求结果为空",
                                               NSURLErrorKey: @"response object is empty"}];
        }
        response = [MNURLResponse responseWithError:error];
        [response setValue:self forKey:MNURLPath(response.request)];
    }
    /**保存response实例*/
    [self setValue:response forKey:MNURLPath(self.response)];
    /**缓存数据, 回调解析数据*/
    if (response.code == MNURLResponseCodeSucceed) {
        if (self.method == MNURLHTTPMethodGet && self.dataSource == MNURLDataSourceNetwork  && self.cachePolicy != MNURLDataCachePolicyNever) {
            NSString *cacheUrl = self.cacheForUrl;
            if (cacheUrl && cacheUrl.length) [[MNURLSessionManager defaultManager] setCache:responseObject forUrl:cacheUrl];
        }
        [self didSucceedWithResponseObject:responseObject];
        if ([self.delegate respondsToSelector:@selector(didSucceedRequesting:responseObject:)]) {
            [self.delegate didSucceedRequesting:self responseObject:responseObject];
        }
    }
    /**请求结束, 回调请求结果*/
    dispatch_async(dispatch_get_main_queue(), ^{
        //1.是否错误
        if (response.code != MNURLResponseCodeSucceed) {
//            NSString *urlStr = [NSString stringWithFormat:@"请求数据失败-URL=%@",response.request.url];
//            [CWCMobClick ym_event:UMActionRequestError param:urlStr];
        }
        if ([self.delegate respondsToSelector:@selector(didFinishRequesting:response:)]) {
            [self.delegate didFinishRequesting:self response:response];
        }
        if (self.finishCallback) self.finishCallback(response);
    });
}

#pragma mark - Getter
- (NSURLSessionDataTask *)dataTask {
    return (NSURLSessionDataTask *)(self.task);
}

- (NSString *)cacheForUrl {
    if (_cacheForUrl) return _cacheForUrl;
    if ([self.delegate respondsToSelector:@selector(requestCacheForUrl:)]) {
        return [self.delegate requestCacheForUrl:self];
    }
    return self.url;
}

#pragma mark - dealloc
- (void)dealloc {
    _delegate = nil;
}

@end
