//
//  UILabel+MNHelper.m
//  MNKit
//
//  Created by Vincent on 2017/12/11.
//  Copyright © 2017年 小斯. All rights reserved.
//

#import "UILabel+MNHelper.h"

@implementation UILabel (MNHelper)
+ (UILabel *)labelWithFrame:(CGRect)frame
                          text:(id)text
                     textColor:(UIColor *)textColor
                          font:(id)font {
    UILabel* label = [[self alloc] initWithFrame:frame];
    label.textFont = font;
    label.string = text;
    if (textColor) label.textColor = textColor;
    return label;
}


+ (UILabel *)labelWithFrame:(CGRect)frame
                          text:(id)text
                     alignment:(NSTextAlignment)alignment
                     textColor:(UIColor*)textColor
                          font:(id)font {
    UILabel *label = [UILabel labelWithFrame:frame text:text textColor:textColor font:font];
    label.textAlignment = alignment;
    return label;
}

- (void)setTextFont:(id)textFont {
    if (!textFont) return;
    if ([textFont isKindOfClass:[UIFont class]]) {
        self.font = (UIFont *)textFont;
    } else if ([textFont isKindOfClass:[NSNumber class]]) {
        self.font = [UIFont systemFontOfSize:[textFont floatValue]];
    }
}

- (id)textFont {
    return self.font;
}

- (void)setString:(id)string {
    if ([string isKindOfClass:[NSString class]]) {
        self.text = (NSString *)string;
    } else if ([string isKindOfClass:[NSAttributedString class]]) {
        self.attributedText = (NSAttributedString *)string;
    }
}

- (id)string {
    if (self.attributedText) return self.attributedText;
    return self.text;
}

- (CGSize)stringSize {
    if (self.attributedText) {
        NSString *string = self.attributedText.string;
        NSDictionary<NSAttributedStringKey, id> *attributes = [self.attributedText attributesAtIndex:0 effectiveRange:nil];
        if (attributes.count && string.length) {
            return [string sizeWithAttributes:attributes];
        }
    }
    if (!self.font || self.text.length <= 0) return CGSizeZero;
    return [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
}

- (CGSize)boundingSizeByWidth {
    if (self.attributedText) {
        NSString *string = self.attributedText.string;
        NSDictionary<NSAttributedStringKey, id> *attributes = [self.attributedText attributesAtIndex:0 effectiveRange:nil];
        if (attributes.count && string.length) {
            return [string boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil].size;
        }
    }
    if (!self.font || self.text.length <= 0) return CGSizeZero;
    return [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
                                options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName: self.font}
                                context:nil].size;
}

- (CGSize)boundingSizeByHeight {
    if (self.attributedText) {
        NSString *string = self.attributedText.string;
        NSDictionary<NSAttributedStringKey, id> *attributes = [self.attributedText attributesAtIndex:0 effectiveRange:nil];
        if (attributes.count && string.length) {
            return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height)
                                        options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil].size;
        }
    }
    if (!self.font || self.text.length <= 0) return CGSizeZero;
    return [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height)
                                options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName: self.font}
                                context:nil].size;
}



//MARK: - 内边距
static char kContentInsetsKey;
static char kshowContentInsetsKey;

- (void)setContentInsets:(UIEdgeInsets)contentInsets

{

 objc_setAssociatedObject(self, &kContentInsetsKey, NSStringFromUIEdgeInsets(contentInsets), OBJC_ASSOCIATION_COPY_NONATOMIC);

  objc_setAssociatedObject(self, &kshowContentInsetsKey, @YES, OBJC_ASSOCIATION_COPY_NONATOMIC);



}

- (UIEdgeInsets)contentInsets

{
 return UIEdgeInsetsFromString(objc_getAssociatedObject(self, &kContentInsetsKey));
}

+ (void)load
{
    [super load];
    
    // class_getInstanceMethod()
    Method fromMethod = class_getInstanceMethod([self class], @selector(drawTextInRect:));
    Method toMethod = class_getInstanceMethod([self class], @selector(tt_drawTextInRect:));
    
    // class_addMethod()
    if (!class_addMethod([self class], @selector(drawTextInRect:), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}


- (void)tt_drawTextInRect:(CGRect)rect
{
    BOOL show = objc_getAssociatedObject(self, &kshowContentInsetsKey);
    if (show) {
        rect = UIEdgeInsetsInsetRect(rect, self.contentInsets);
    }
    [self tt_drawTextInRect:rect];
}



///置顶显示
- (void)xg_setAlignmentTop
{
    // 对应字号的字体一行显示所占宽高
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    // 多行所占 height*line
    double height = self.frame.size.height;
    // 显示范围实际宽度
    double width = self.frame.size.width;
    // 对应字号的内容实际所占范围
    CGSize stringSize = [self.text boundingRectWithSize:CGSizeMake(width, height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:nil].size;
    // 剩余空行
    NSInteger line = (height - stringSize.height) / fontSize.height;
    // 用回车补齐
    for (int i = 0; i < line; i++) {
        
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}
///置底显示
- (void)xg_setAlignmentBottom
{
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    double height = fontSize.height*self.numberOfLines;
    double width = self.frame.size.width;
    CGSize stringSize = [self.text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    NSInteger line = (height - stringSize.height) / fontSize.height;
    // 前面补齐换行符
    for (int i = 0; i < line; i++) {
        self.text = [NSString stringWithFormat:@" \n%@", self.text];
    }
}


@end
