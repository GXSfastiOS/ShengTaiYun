//
//  GXSUser.m
//  TeamAlbum
//
//  Created by Vicent on 2020/8/27.
//

#import "GXSUser.h"

#define kFLUserInfo  @"com.fl.user.info.key"
#define dispatch_update_queue     user_update_queue()
static dispatch_queue_t user_update_queue (void) {
    static dispatch_queue_t user_update_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 串行队列使用户信息依次更新
        user_update_queue = dispatch_queue_create("com.fl.user.update.queue", DISPATCH_QUEUE_SERIAL);
    });
    return user_update_queue;
}

@interface GXSUser ()
@property (nonatomic, copy) NSString *token;
@end

static GXSUser *_user;
@implementation GXSUser
+ (GXSUser *)shareInfo {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[GXSUser alloc] init];
        [_user updateUserInfo:[NSUserDefaults.standardUserDefaults dictionaryForKey:kFLUserInfo] writeToFile:NO];
    });
    return _user;
}

- (void)updateUserInfo:(NSDictionary *)userInfo {
    [self updateUserInfo:userInfo writeToFile:YES];
}

- (void)updateUserInfo:(NSDictionary *)userInfo writeToFile:(BOOL)writeToFile {
    if (!userInfo) userInfo = @{};
    self.token = [NSDictionary stringValueWithDictionary:userInfo forKey:@"token" def:@""];
    self.uid = [NSDictionary stringValueWithDictionary:userInfo forKey:@"userId" def:@""];
    self.nick = [NSDictionary stringValueWithDictionary:userInfo forKey:@"nick" def:@""];
    self.heading = [NSDictionary stringValueWithDictionary:userInfo forKey:@"heading" def:@""];
    self.mobile = [NSDictionary stringValueWithDictionary:userInfo forKey:@"mobile" def:@""];
    self.expirationTime = [NSDictionary stringValueWithDictionary:userInfo forKey:@"expirationTime" def:@""];
    self.vip = [NSDictionary boolValueWithDictionary:userInfo forKey:@"isVip"];
    self.sex = [NSDictionary integerValueWithDictionary:userInfo forKey:@"sex"];
    self.miniprogramcode_url = [NSDictionary stringValueWithDictionary:userInfo forKey:@"miniprogramcode_url" def:@""];
    self.wechat_qrcode = [NSDictionary stringValueWithDictionary:userInfo forKey:@"wechat_url" def:@""];
    self.wechat_number = [NSDictionary stringValueWithDictionary:userInfo forKey:@"wechat_number" def:@""];
    self.signature = [NSDictionary stringValueWithDictionary:userInfo forKey:@"sign" def:@""];
    if (writeToFile) {
        [NSUserDefaults synchronly:^(NSUserDefaults * _Nonnull userDefaults) {
            [userDefaults setObject:userInfo forKey:kFLUserInfo];
        }];
    }
}

+ (void)updateUserInfo:(void(^)(BOOL isSuccess, NSString *errorMsg))completion {
    static GXSHTTPDataRequest *updateUserInfoRequest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        updateUserInfoRequest = [GXSHTTPDataRequest new];
        updateUserInfoRequest.cachePolicy = MNURLDataCachePolicyNever;
        updateUserInfoRequest.allowsCellularAccess = YES;
        updateUserInfoRequest.allowsNetworkActivity = YES;
        updateUserInfoRequest.timeoutInterval = 10.f;
        updateUserInfoRequest.url = URL_HANDING(@"api/v1/users/infos");
    });
    [updateUserInfoRequest cancel];
    [updateUserInfoRequest loadData:nil completion:^(MNURLResponse *response) {
        if (response.code == MNURLResponseCodeSucceed) {
            /// 更新用户信息
            NSDictionary *data = [NSDictionary dictionaryValueWithDictionary:response.data forKey:@"data"];
            [GXSUser.shareInfo updateUserInfo:data writeToFile:YES];
            [NSNotificationCenter.defaultCenter postNotificationName:FLUserUpdateNotificationName object:GXSUser.shareInfo];
        }
        if (completion) {
            completion(response.code == MNURLResponseCodeSucceed, response.message);
        }
    }];
}

- (void)cleanUserInfo {
    [self updateUserInfo:@{} writeToFile:YES];
}

- (BOOL)synchronize {
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:self.token ? : @"" forKey:kPath(self.token)];
    [dic setObject:self.uid ? : @"" forKey:@"userId"];
    [dic setObject:self.nick ? : @"" forKey:kPath(self.nick)];
    [dic setObject:self.heading ? : @"" forKey:kPath(self.heading)];
    [dic setObject:self.mobile ? : @"" forKey:kPath(self.mobile)];
    [dic setObject:self.expirationTime ? : @"" forKey:kPath(self.expirationTime)];
    [dic setObject:self.wechat_qrcode ? : @"" forKey:@"wechat_url"];
    [dic setObject:self.wechat_number ? : @"" forKey:kPath(self.wechat_number)];
    [dic setObject:self.miniprogramcode_url ? : @"" forKey:kPath(self.miniprogramcode_url)];
    [dic setObject:self.signature ? : @"" forKey:@"sign"];
    [dic setObject:@(self.isVip) forKey:kPath(self.vip)];
    [dic setObject:@(self.sex) forKey:kPath(self.sex)];
    [NSUserDefaults synchronly:^(NSUserDefaults * _Nonnull userDefaults) {
        [userDefaults setObject:dic forKey:kFLUserInfo];
    }];
    return YES;
}

- (NSString *)fileNameWithExtension:(NSString *)extension {
    NSMutableString *filePath = @"".mutableCopy;
    if (self.uid.length) {
        [filePath appendString:self.token];
        [filePath appendString:@"/"];
    }
    [filePath appendString:[MNFileHandle fileNameWithExtension:extension]];
    return filePath.copy;
}

#pragma mark - Getter
- (BOOL)isLogin {
    return (self.token.length > 0 && self.uid.length > 0);
}

- (NSString *)token {
    return _token ? : @"";
}

@end
