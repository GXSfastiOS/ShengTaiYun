//
//  MineSignModel.h
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineSignModel : NSObject
//打卡次数
@property (nonatomic,strong)NSString *daka_id;
//打卡地点
@property (nonatomic,strong)NSString *daka_name;
//打卡图
@property (nonatomic,strong)NSString *daka_pic;
@end

NS_ASSUME_NONNULL_END
