//
//  TaskModel.h
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : NSObject
//问题编号
@property (nonatomic,strong)NSString *questionId;
//发布时间
@property (nonatomic,strong)NSString *fubuTime;
//审核人员
@property (nonatomic,strong)NSString *reviewPreson;
//分管领导
@property (nonatomic,strong)NSString *fenGuanLingDao;

@end

NS_ASSUME_NONNULL_END
