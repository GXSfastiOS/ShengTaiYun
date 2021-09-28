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
@property (nonatomic,strong)UILabel *gongGaoTitle;
//展示部分
@property (nonatomic,strong)UILabel *gongGaoMore;
//发布时间
@property (nonatomic,strong)UILabel *gongGaoTime;
@end

NS_ASSUME_NONNULL_END
