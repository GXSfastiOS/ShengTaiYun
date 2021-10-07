//
//  ForGetPassworldView.h
//  GXSShengTaiYunProject
//
//  Created by guoxianshudeMac on 2021/10/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForGetPassworldView : UIView
- (instancetype)initWithFrame:(CGRect)frame returnValue:(void(^)(NSString *zhanghao,NSString *oldPassworld ,NSString *passworld,NSString *sumbitPassworld)) returnInfo;
@end

NS_ASSUME_NONNULL_END
