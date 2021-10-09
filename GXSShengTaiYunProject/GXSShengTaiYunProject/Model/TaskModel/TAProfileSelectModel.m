//
//  TAProfileSelectModel.m
//  TeamAlbum
//
//  Created by Vicent on 2020/9/9.
//

#import "TAProfileSelectModel.h"
#import "MNAsset.h"
#import "TAProfileSelectModel.h"

@interface TAProfileSelectModel ()
@property (nonatomic) TAProfileType type;
@property (nonatomic, getter=isLast) BOOL last;
@property (nonatomic, copy) NSString *preview;
@property (nonatomic, copy) UIImage *thumbnail;
@property (nonatomic, copy) id content;
@end

@implementation TAProfileSelectModel
+ (TAProfileSelectModel *)lastProfile {
    TAProfileSelectModel *model = TAProfileSelectModel.new;
    model.last = YES;
    model.type = TAProfileTypePhoto;
    model.content = model.thumbnail = [UIImage imageNamed:@"new_last_pofile"];
    return model;
}

+ (TAProfileSelectModel *)modelWithAsset:(MNAsset *)asset {
    TAProfileSelectModel *model = TAProfileSelectModel.new;
    model.type = asset.type == MNAssetTypePhoto ? TAProfileTypePhoto : TAProfileTypeVideo;
    model.thumbnail = asset.thumbnail;
    model.content = asset.content;
    return model;
}

//+ (TAProfileSelectModel *)modelWithProfile:(TAProfileModel *)profile {
//    TAProfileSelectModel *model = TAProfileSelectModel.new;
//    model.type = profile.type;
//    if (profile.thumbnail) {
//        // 图片抓取传来的模型
//        model.thumbnail = profile.thumbnail;
//        model.content = profile.image;
//    } else {
//        // 产品传过来的 直接使用地址即可
//        model.preview = profile.preview;
//        model.content = profile.url;
//    }
//    return model;
//}

@end
