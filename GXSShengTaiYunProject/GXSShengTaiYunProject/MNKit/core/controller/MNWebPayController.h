//
//  MNWebPayController.h
//  MNKit
//
//  Created by Vicent on 2020/4/24.
//  Copyright © 2020 Vincent. All rights reserved.
//  网页支付处理

#import "MNWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 WX回调我方域名<example:// 或 example>
*/
UIKIT_EXTERN void MNWebPaySetDomain (NSString *);
/**
 ZFB回调我方APP标识<URL type 标识>
*/
UIKIT_EXTERN void MNWebPaySetScheme (NSString *);

@interface MNWebPayController : MNWebViewController

/**
 支付成功, 检查订单并回调结果
*/
@property (nonatomic, copy) void(^didFinishPayHandler)(void(^resultHandler)(BOOL, NSString *_Nullable));

/**
 处理回调检查
*/
+ (BOOL)handOpenUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
