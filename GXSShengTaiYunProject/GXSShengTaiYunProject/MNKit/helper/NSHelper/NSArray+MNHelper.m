//
//  NSArray+MNHelper.m
//  MNKit
//
//  Created by Vincent on 2018/10/29.
//  Copyright © 2018年 小斯. All rights reserved.
//

#import "NSArray+MNHelper.h"
#import <objc/runtime.h>

@implementation NSArray (MNHelper)
#pragma mark - 求值
- (CGFloat)sum {
    NSNumber *value = [self sumValueForKeyPath:@"floatValue"];
    return value ? value.floatValue : 0.f;
}

- (CGFloat)avg {
    NSNumber *value = [self avgValueForKeyPath:@"floatValue"];
    return value ? value.floatValue : 0.f;
}

- (CGFloat)max {
    NSNumber *value = [self maxValueForKeyPath:@"floatValue"];
    return value ? value.floatValue : 0.f;
}

- (CGFloat)min {
    NSNumber *value = [self minValueForKeyPath:@"floatValue"];
    return value ? value.floatValue : 0.f;
}

- (NSNumber *)sumValueForKeyPath:(NSString *)keyPath {
    if (!keyPath || keyPath.length <= 0) return nil;
    if (![[keyPath substringToIndex:1] isEqualToString:@"."]) keyPath = [@"." stringByAppendingString:keyPath];
    return [self valueForKeyPath:[NSString stringWithFormat:@"@sum%@", keyPath]];
}

- (NSNumber *)avgValueForKeyPath:(NSString *)keyPath {
    if (!keyPath || keyPath.length <= 0) return nil;
    if (![[keyPath substringToIndex:1] isEqualToString:@"."]) keyPath = [@"." stringByAppendingString:keyPath];
    return [self valueForKeyPath:[NSString stringWithFormat:@"@avg%@", keyPath]];
}

- (NSNumber *)maxValueForKeyPath:(NSString *)keyPath {
    if (!keyPath || keyPath.length <= 0) return nil;
    if (![[keyPath substringToIndex:1] isEqualToString:@"."]) keyPath = [@"." stringByAppendingString:keyPath];
    return [self valueForKeyPath:[NSString stringWithFormat:@"@max%@", keyPath]];
}

- (NSNumber *)minValueForKeyPath:(NSString *)keyPath {
    if (!keyPath || keyPath.length <= 0) return nil;
    if (![[keyPath substringToIndex:1] isEqualToString:@"."]) keyPath = [@"." stringByAppendingString:keyPath];
    return [self valueForKeyPath:[NSString stringWithFormat:@"@min%@", keyPath]];
}

#pragma mark - 分割数组
- (NSArray <NSArray *>*)componentArrayByCapacity:(NSUInteger)count {
    if (count <= 0 || self.count <= 0) return nil;
    NSUInteger number = self.count%count == 0 ? (self.count/count) : (self.count/count + 1);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:number];
    for (NSUInteger i = 0; i < number; i ++) {
        NSUInteger location = i*count;
        NSUInteger length = self.count - location >= count ? count : (self.count - location);
        NSArray *subArray = [self subarrayWithRange:NSMakeRange(location, length)];
        [array addObject:subArray];
    }
    return array.copy;
}

#pragma mark - 倒序数组
- (NSArray *)reverseObjects {
    return [[self.copy reverseObjectEnumerator] allObjects];
}

#pragma mark - 随机元素
- (id)randomObject {
    if (self.count <= 0) return nil;
    NSInteger index = arc4random()%self.count;
    return [self objectAtIndex:index];
}

@end

@implementation NSMutableArray (MNHelper)
#pragma mark - 移动元素
- (void)moveSubjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex {
    if (toIndex == index || index >= self.count) return;
    if (toIndex > index) {
        // 下移
        if (toIndex >= self.count) toIndex = self.count - 1;
    }
    toIndex = MAX(0, toIndex);
    // 约束了索引, 要再次判断
    if (toIndex == index) return;
    id obj = [self objectAtIndex:index];
    [self removeObject:obj];
    [self insertObject:obj atIndex:toIndex];
}

- (void)moveSubject:(id)subject toIndex:(NSInteger)toIndex {
    if (![self containsObject:subject]) return;
    NSUInteger index = [self indexOfObject:subject];
    [self moveSubjectAtIndex:index toIndex:toIndex];
}

- (void)bringSubjectToFront:(id)subject {
    if (!subject) return;
    if ([self containsObject:subject]) {
        NSUInteger idx = [self indexOfObject:subject];
        [self bringSubjectToFrontAtIndex:idx];
    } else {
        [self insertObject:subject atIndex:0];
    }
}

- (void)sendSubjectToBack:(id)subject {
    if (!subject) return;
    if ([self containsObject:subject]) {
        NSUInteger idx = [self indexOfObject:subject];
        [self sendSubjectToBackAtIndex:idx];
    } else {
        [self addObject:subject];
    }
}

- (void)bringSubjectToFrontAtIndex:(NSUInteger)index {
    if (self.count <= 0 || index >= self.count) return;
    id obj = [self objectAtIndex:index];
    [self removeObject:obj];
    [self insertObject:obj atIndex:0];
}

- (void)sendSubjectToBackAtIndex:(NSUInteger)index {
    if (self.count <= 0 || index >= self.count) return;
    id obj = [self objectAtIndex:index];
    [self removeObject:obj];
    [self addObject:obj];
}

- (void)insertObjects:(NSArray *)objects fromIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i];
        i++;
    }
}

- (BOOL)insertObject:(id)object afterObject:(id)afterObject {
    if (!object || !afterObject || [self containsObject:object] || ![self containsObject:afterObject]) return NO;
    NSUInteger index = [self indexOfObject:afterObject];
    [self insertObject:object atIndex:(index + 1)];
    return YES;
}


@end
