//
//  MNWebViewController.h
//  MNKit
//
//  Created by Vincent on 2018/11/29.
//  Copyright © 2018年 小斯. All rights reserved.
//  网页控制器基类

#import "MNExtendViewController.h"
#import "MNWebProgressView.h"
#import "MNWebUserContentController.h"
@class WKWebView;
@protocol WKUIDelegate, WKNavigationDelegate, MNScriptMessageHandler;

UIKIT_EXTERN const CGFloat MNWebViewBackViewTag;
UIKIT_EXTERN NSString * _Nonnull const MNWebViewExitScriptMessageName;
UIKIT_EXTERN NSString * _Nonnull const MNWebViewBackScriptMessageName;
UIKIT_EXTERN NSString * _Nonnull const MNWebViewReloadScriptMessageName;

NS_ASSUME_NONNULL_BEGIN

@interface MNWebViewController : MNExtendViewController<WKUIDelegate,WKNavigationDelegate,MNScriptMessageHandler>
/**
 链接
 */
@property (nonatomic, copy) NSString *url;
/**
 交互信息名
 */
@property (nonatomic, strong) NSArray <NSString *>*scriptMessages;
/**
 是否在加载
 */
@property (nonatomic, readonly, getter=isLoading) BOOL loading;
/**
 是否充值VIP页面
 */
@property (nonatomic, assign, getter=isVIPInfo) BOOL VIPInfo;
/**
 内部使用的webView
 */
@property (nonatomic, strong, readonly) WKWebView *webView;
/**
 进度条
 */
@property (nonatomic, strong, readonly) MNWebProgressView *progressView;
/**
 JS交互代理
 */
@property (nonatomic, strong, readonly) MNWebUserContentController *contentController;
/**
 控制器显现时, 重载页面<第一次加载时必然重载, 不受此属性控制>
*/
@property (nonatomic, getter=isAllowsReloadWhenAppear) BOOL allowsReloadWhenAppear;

/**
 实例化网页控制器
 @param url 网址
 @return 网页控制器
 */
- (instancetype)initWithUrl:(NSString *_Nullable)url;

/**
 实例化网页控制器
 @param URL 网址
 @return 网页控制器
 */
- (instancetype)initWithURL:(NSURL *_Nullable)URL;

/**
 实例化网页控制器
 @param url 网址
 @param title 标题
 @return 网页控制器
 */
- (instancetype)initWithUrl:(NSString *_Nullable)url title:(NSString *_Nullable)title;

/**
 实例化网页控制器
 @param html 网页数据
 @param baseURL 网页数据
 @return 网页控制器
 */
- (instancetype)initWithHTML:(NSString *)html baseURL:(NSURL *_Nullable)baseURL;

/**
 加载网页请求
 @param req NSURLRequest/NSURL/NSString
 */
- (void)loadRequest:(id)req;

/**
 处理网页请求 子类可定制
 @param req NSURLRequest/NSURL/NSString
 @return 加载的请求
 */
- (NSURLRequest *_Nullable)handRequest:(id)req;

/**
 重载网页
 */
- (void)reload;

/**
 停止加载
 */
- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
