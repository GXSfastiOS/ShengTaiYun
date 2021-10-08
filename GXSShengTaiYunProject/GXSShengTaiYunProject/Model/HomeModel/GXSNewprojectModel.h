//
//  GXSNewprojectModel.h
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXSNewprojectModel : NSObject
//组名
@property (nonatomic,strong)NSString *title;
//隐藏或展示
@property (nonatomic,assign)BOOL isShow;
//分组下行数据集合
@property (nonatomic,strong)NSMutableArray *listArray;
@end

NS_ASSUME_NONNULL_END
