//
//  ListCellTypeModel.h
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/8.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    typeSelect,
    typeTextField,
} ListInfotype;

NS_ASSUME_NONNULL_BEGIN

@interface ListCellTypeModel : NSObject
//title
@property (nonatomic,strong)NSString *title;
//datail
@property (nonatomic,strong)NSString *datail;
//type
@property (nonatomic,assign)ListInfotype type;
@end

NS_ASSUME_NONNULL_END
