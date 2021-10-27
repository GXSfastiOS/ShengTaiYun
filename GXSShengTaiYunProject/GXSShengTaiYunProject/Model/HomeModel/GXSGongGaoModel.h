//
//  GXSGongGaomodel.h
//  GXSShengTaiYunProject
//
//  Created by guoxianshudeMac on 2021/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXSGongGaoModel : NSObject
//公告类型
@property (nonatomic,strong)NSString *title;
//展示部分
@property (nonatomic,strong)NSString *jianjie;
//发布时间
@property (nonatomic,strong)NSString *add_date;
//发布时间
@property (nonatomic,strong)NSString *add_time;
//发布人
@property (nonatomic,strong)NSString *author;
//发布内容
@property (nonatomic,strong)NSString *content;
@end

NS_ASSUME_NONNULL_END
