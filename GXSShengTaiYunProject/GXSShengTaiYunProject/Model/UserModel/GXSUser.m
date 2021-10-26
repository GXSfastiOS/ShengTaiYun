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
    self.uid = [NSDictionary stringValueWithDictionary:userInfo forKey:@"id" def:@""];
    self.user = [NSDictionary stringValueWithDictionary:userInfo forKey:@"nick_name" def:@""];
    self.nick_name = [NSDictionary stringValueWithDictionary:userInfo forKey:@"nick_name" def:@""];
    self.head_pic = [NSDictionary stringValueWithDictionary:userInfo forKey:@"head_pic" def:@""];
    self.mobile = [NSDictionary stringValueWithDictionary:userInfo forKey:@"mobile" def:@""];
    self.wangge_name = [NSDictionary stringValueWithDictionary:userInfo forKey:@"wangge_name" def:@""];
    self.lingdao_name = [NSDictionary stringValueWithDictionary:userInfo forKey:@"lingdao_names" def:@""];
    self.sex = [NSDictionary integerValueWithDictionary:userInfo forKey:@"sex"];
    self.type = [NSDictionary integerValueWithDictionary:userInfo forKey:@"type"];
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
    [dic setObject:@(self.type) ? : @"" forKey:kPath(self.type)];
    [dic setObject:self.user ? : @"" forKey:kPath(self.user)];
    [dic setObject:self.nick_name ? : @"" forKey:kPath(self.nick_name)];
    [dic setObject:self.head_pic ? : @"" forKey:kPath(self.head_pic)];
    [dic setObject:self.mobile ? : @"" forKey:kPath(self.mobile)];
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
