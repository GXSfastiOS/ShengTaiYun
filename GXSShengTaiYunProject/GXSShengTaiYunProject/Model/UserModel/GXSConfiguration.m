//
//  GXSConfiguration.m
//  TeamAlbum
//
//  Created by Vicent on 2020/8/27.
//

#import "GXSConfiguration.h"

#define kFLBaseacturl @"http://shengtai.yuenkeji.com"
#define kFLIdentifier @"com.fl.shortcuts.identifier.key"
#define kFLEnabled @"com.fl.shortcuts.enabled.key"
#define kFLAccessToken @"com.fl.shortcuts.access.token.key"
#define kGXSConfiguration @"com.fl.shortcuts.configuration.key"

@interface GXSConfiguration ()
@property (nonatomic, getter=isEnabled) BOOL enabled;
@end

static GXSConfiguration *_configuration;
@implementation GXSConfiguration
+ (GXSConfiguration *)shareInstance {
    return [GXSConfiguration configuration];
}

+ (GXSConfiguration *)configuration {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _configuration = [[GXSConfiguration alloc] init];
    });
    return _configuration;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _configuration = [super allocWithZone:zone];
    });
    return _configuration;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _configuration = [super init];
        _configuration->_baseacturl = kFLBaseacturl;
        [_configuration updateConfiguration:([NSUserDefaults.standardUserDefaults dictionaryForKey:kGXSConfiguration] ? : @{}) writeToFile:NO];
        _configuration->_enabled = [NSUserDefaults boolForKey:kFLEnabled def:NO];
        _configuration->_access_token = [NSUserDefaults stringForKey:kFLAccessToken def:@""];
        _configuration->_language = [NSString replacingEmptyCharacters:NSLocaleLanguage() withCharacters:@"zh-Hans-CN"];
    });
    return _configuration;
}

+ (void)requestRemoteConfigurationIfNeeded:(void (^_Nullable)(BOOL))completionHandler {
    if (GXSConfiguration.configuration.isEnabled) {
        if (completionHandler) completionHandler(YES);
        return;
    }
    [self requestRemoteConfigurationWithCompletionHandler:completionHandler];
}

+ (void)requestRemoteConfigurationWithCompletionHandler:(void (^)(BOOL))completionHandler {
    static GXSHTTPDataRequest *request;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = GXSHTTPDataRequest.new;
        request.pagingEnabled = NO;
        request.timeoutInterval = 5.f;
        request.allowsCellularAccess = YES;
        request.allowsNetworkActivity = YES;
        request.method = MNURLHTTPMethodGet;
        request.cachePolicy = MNURLDataCachePolicyNever;
    });
    if (request.isLoading) {
        if (completionHandler) completionHandler(NO);
        return;
    }
    request.url = URL_HANDING(@"api/v1/config");
    [request loadData:nil completion:^(MNURLResponse * _Nonnull response) {
        if (response.code == MNURLResponseCodeSucceed) {
            GXSConfiguration *configuration = GXSConfiguration.configuration;
            NSDictionary *data = [NSDictionary dictionaryValueWithDictionary:response.data forKey:@"data"];
            [configuration updateConfiguration:data writeToFile:YES];
            if (configuration.isEnabled) {
                [NSUserDefaults synchronly:^(NSUserDefaults * _Nonnull userDefaults) {
                    [userDefaults setBool:YES forKey:kFLEnabled];
                }];
            }
            if ([NSDictionary boolValueWithDictionary:data forKey:@"del_local_purchase"]) {
                [MNPurchaseManager.defaultManager removeAllReceipts];
            }
        }
        if (completionHandler) completionHandler(response.code == MNURLResponseCodeSucceed);
    }];
}

- (void)updateConfiguration:(NSDictionary *)data writeToFile:(BOOL)writeToFile {
    if (!data) data = @{};
    self.baseacturl = [NSDictionary stringValueWithDictionary:data forKey:@"baseacturl" def:kFLBaseacturl];
    if (data.count) self.enabled = ![NSDictionary boolValueWithDictionary:data forKey:@"status"];
    if (writeToFile) {
        [NSUserDefaults synchronly:^(NSUserDefaults * _Nonnull userDefaults) {
            [userDefaults setObject:data forKey:kGXSConfiguration];
        }];
    }
}

#pragma mark - Setter
- (void)setBaseacturl:(NSString *)baseacturl {
    if ([NSString isEmptyString:baseacturl]) return;
    _baseacturl = baseacturl.copy;
}

- (void)setAccess_token:(NSString *)access_token {
    @synchronized (self) {
        access_token = [NSString replacingEmptyCharacters:access_token];
        _access_token = access_token.copy;
        [NSUserDefaults synchronly:^(NSUserDefaults * _Nonnull userDefaults) {
            [userDefaults setObject:access_token forKey:kFLAccessToken];
        }];
    }
}

#pragma mark - Getter
+ (NSString *)identifier {
    static NSString *ta_identifier;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ta_identifier = [MNKeychain stringForKey:kFLIdentifier];
        if (ta_identifier.length <= 0) {
            ta_identifier = MNFileHandle.fileName;
            [MNKeychain setString:ta_identifier forKey:kFLIdentifier];
        }
    });
    return ta_identifier;
}

- (NSString *)handUrl:(NSString *)url {
    if (!url || url.length <= 0) return self.baseacturl;
    if ([[url substringToIndex:1] isEqualToString:@"/"]) url = [url substringFromIndex:1];
    NSMutableString *string = self.baseacturl.mutableCopy;
    if (![string hasSuffix:@"/"]) [string appendString:@"/"];
    [string appendString:url];
    return string.copy;
}

@end
