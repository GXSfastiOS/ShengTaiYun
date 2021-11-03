//
//  FMPrejectView.h
//  FMFastMasterPreject
//
//  Created by fenglikejiInfomation on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, prejectTypeInfo) {
    loadTypeInfoAll = 0,
    loadTypeInfoMine = 1,
    loadTypeInfoOther = 2,
};

@interface FMPrejectView : UIView
@property  (nonatomic,assign)NSInteger cid;

@end

NS_ASSUME_NONNULL_END
