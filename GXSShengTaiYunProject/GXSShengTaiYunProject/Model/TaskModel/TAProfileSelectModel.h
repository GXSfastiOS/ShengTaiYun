//
//  TAProfileSelectModel.h
//  TeamAlbum
//
//  Created by Vicent on 2020/9/9.
//  配图选择模型


/**定义文件类型*/
typedef NS_ENUM(NSInteger, TAProfileType) {
    TAProfileTypePhoto = 1, //图片
    TAProfileTypeVideo // 视频
};

#import <Foundation/Foundation.h>
//#import "TAProfileModel.h"
@class MNAsset, TAProfileModel;



NS_ASSUME_NONNULL_BEGIN

@interface TAProfileSelectModel : NSObject

/**视频/图片*/
@property (nonatomic, readonly) TAProfileType type;

/**是否是最后一项*/
@property (nonatomic, getter=isLast, readonly) BOOL last;

/**预览链接*/
@property (nonatomic, copy, nullable, readonly) NSString *preview;

/**缩略图*/
@property (nonatomic, copy, nullable, readonly) UIImage *thumbnail;

/**图片或视频链接*/
@property (nonatomic, copy, readonly) id content;

/**
 获取最后一项模型
 @return 最后一项模型
 */
+ (TAProfileSelectModel *)lastProfile;

/**
 依据资源实例化选择模型
 @param asset 资源模型
 @return 选择模型
 */
+ (TAProfileSelectModel *)modelWithAsset:(MNAsset *)asset;

/**
 依据配图实例化选择模型
 @param profile 配图模型
 @return 选择模型
 */
//+ (TAProfileSelectModel *)modelWithProfile:(TAProfileModel *)profile;

@end

NS_ASSUME_NONNULL_END
