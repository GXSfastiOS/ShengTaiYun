//
//  UIImage+MNHelper.m
//  MNKit
//
//  Created by Vincent on 2017/10/10.
//  Copyright © 2017年 小斯. All rights reserved.
//

#import "UIImage+MNHelper.h"
#import "UIColor+MNHelper.h"
#import "CALayer+MNHelper.h"
#import <Accounts/Accounts.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#if __has_include("SDWebImageManager.h")
#import "SDWebImageManager.h"
#endif
#if __has_include(<SDWebImage/SDWebImageManager.h>)
#import <SDWebImage/SDWebImageManager.h>
#endif

@implementation UIImage (MNHelper)
#pragma mark - 图案颜色
- (UIColor *)patternColor {
    return [UIColor colorWithPatternImage:self];
}

#pragma mark - 图片大小
- (CGSize)imageSize {
    return CGSizeMake(self.size.width*self.scale, self.size.height*self.scale);
}

#pragma mark - 获取Assets图片
UIImage * UIImageNamed (NSString *name) {
    return [UIImage imageNamed:name];
}

#pragma mark - 获取纯色图
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.f, 1.f)];
}

UIImage* UIImageWithColor (UIColor *color) {
    return [UIImage imageWithColor:color];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0.f || size.height <= 0.f) return nil;
    size.width = floor(size.width);
    size.height = floor(size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){0.f, 0.f, size});
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 取图片某一点颜色
- (UIColor *)colorAtPoint:(CGPoint)point {
    if (!CGRectContainsPoint((CGRect){0.f, 0.f, self.size}, point)) return nil;
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel*1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY- (CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

UIColor * UIColorAtImagePoint (UIImage *image, CGPoint point) {
    return [image colorAtPoint:point];
}

#pragma mark - layer转换为image
+ (UIImage *)imageWithLayer:(CALayer *)layer {
    if (!layer) return nil; 
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, layer.contentsScale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithLayer:(CALayer *)layer rect:(CGRect)rect {
    if (!layer || CGRectEqualToRect(rect, CGRectZero)) return nil;
    UIImage *image = [self imageWithLayer:layer];
    CGImageRef imageRef = image.CGImage;
    if (!imageRef) return nil;
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat ratio = width/layer.frame.size.width;
    rect = CGRectMake(floor(rect.origin.x*ratio), floor(rect.origin.y*ratio), floor(rect.size.width*ratio), floor(rect.size.height*ratio));
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(imageRef, rect) scale:image.scale orientation:image.imageOrientation];
}

#pragma mark - UIView转化为UIImage
+ (UIImage *)imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterScreenUpdates {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:afterScreenUpdates];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 原图,避免着色
- (UIImage *)originalImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - 模板图
- (UIImage *)templateImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - 获取image
+ (UIImage *)imageWithObject:(id)obj {
    if (!obj) return nil;
    UIImage *image;
    if ([obj isKindOfClass:[NSString class]]) {
        if ([NSFileManager.defaultManager fileExistsAtPath:obj]) {
            image = [UIImage imageWithContentsOfFile:(NSString *)obj];
        } else if ([(NSString *)obj hasPrefix:@"http://"] || [(NSString *)obj hasPrefix:@"https://"]) {
#if __has_include("SDWebImageManager.h") || __has_include(<SDWebImage/SDWebImageManager.h>)
//            image = [SDWebImageManager.sharedManager.imageCache imageFromCacheForKey:nil];
#endif
            if (!image) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)obj]];
                if (data.length) image = [UIImage imageWithData:data];
            }
        } else {
            image = [UIImage imageNamed:(NSString *)obj];
        }
    } else if ([obj isKindOfClass:[NSURL class]]) {
        NSURL *URL = (NSURL *)obj;
        image = [self imageWithObject:URL.isFileURL ? URL.path : URL.absoluteString];
    } else if ([obj isKindOfClass:[UIImage class]]) {
        image = (UIImage *)obj;
    }
    return image;
}

#pragma mark - 获取LogoImage
+ (UIImage *)logoImage {
    static UIImage *_logoImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *name = [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        _logoImage = [UIImage imageNamed:name];
    });
    return _logoImage;
}

#pragma mark - 获取LaunchImage
+ (UIImage *)launchImage {
    static UIImage *launchImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *orientation = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? @"Portrait" : @"Landscape";
        NSString *imageName;
        CGSize screen_size = [[UIScreen mainScreen] bounds].size;
        NSArray *array = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        for(NSDictionary *dic in array) {
            CGSize size = CGSizeFromString(dic[@"UILaunchImageSize"]);
            if ([orientation isEqualToString:dic[@"UILaunchImageOrientation"]] && (CGSizeEqualToSize(size, screen_size) || (size.width == screen_size.height && size.height == screen_size.width))) {
                imageName = dic[@"UILaunchImageName"];
                launchImage = [UIImage imageNamed:imageName];
            }
        }
    });
    return launchImage;
}

#pragma mark - 获取图片尺寸
+ (CGSize)imageSizeWithUrl:(NSString *)url animated:(BOOL *)animated {
    if (url.length <= 0) return CGSizeZero;
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        return [self imageSizeWithURL:[NSURL URLWithString:url] animated:animated];
    } else if ([url hasPrefix:@"file://"]) {
        if (animated) *animated = [[url pathExtension] isEqualToString:@"gif"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:url]];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                return image.size;
            }
        }
    } else {
        if (animated) *animated = NO;
        UIImage *image = [UIImage imageNamed:url];
        if (image) {
            return image.size;
        }
    }
    return CGSizeZero;
}

+ (CGSize)imageSizeWithURL:(NSURL *)URL animated:(BOOL *)animated {
    if (!URL) return CGSizeZero;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    CGSize size = CGSizeZero;
    BOOL isAnimated = NO;
    if ([pathExtendsion isEqualToString:@"png"]) {
        size = [self PNGImageSizeWithRequest:request];
    } else if ([pathExtendsion isEqual:@"gif"]) {
        isAnimated = YES;
        size = [self GIFImageSizeWithRequest:request];
    } else {
        size = [self JPGImageSizeWithRequest:request];
    }
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:URL]];
        if (image) {
            size = image.size;
        }
    }
    if (animated) {
        *animated = isAnimated;
    }
    return size;
}

+ (CGSize)PNGImageSizeWithRequest:(NSMutableURLRequest*)request {
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data.length == 8) {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

+ (CGSize)GIFImageSizeWithRequest:(NSMutableURLRequest*)request {
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data.length == 4) {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

+ (CGSize)JPGImageSizeWithRequest:(NSMutableURLRequest*)request {
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ([data length] <= 0x58) return CGSizeZero;
    if ([data length] < 210) {
        // 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {
                // 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        }
    }
    return CGSizeZero;
}

@end


@implementation UIImage (MNCoding)
#pragma mark - 获取Data图片
- (NSData *)JPEGData {
    return UIImageJPEGRepresentation(self, 1.f);
}

- (NSData *)PNGData {
    return UIImagePNGRepresentation(self);
}

#pragma mark - UIImage转NSString
- (NSString *)JPEGBase64Encoding {
    NSData *data = UIImageJPEGRepresentation(self, 1.f);
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)PNGBase64Encoding {
    NSData *data = UIImagePNGRepresentation(self);
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark - NSString转UIImage
+ (UIImage *)imageWithBase64EncodedString:(NSString *)base64String {
    if (base64String.length <= 0) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (data.length <= 0) return nil;
    return [UIImage imageWithData:data];
}

@end


@implementation UIImage (MNResizing)
#pragma mark - 拉伸图像
+ (UIImage *)resizableImage:(NSString *)imgName {
    UIImage *image = [UIImage imageNamed:imgName];
    return [self resizableImage:imgName capInsets:UIEdgeInsetsMake(image.size.height *.5f, image.size.width*.5f, image.size.height*.5f, image.size.width*.5f)];
}

+ (UIImage *)resizableImage:(NSString *)imgName capInsets:(UIEdgeInsets)capInsets {
    UIImage *image = [UIImage imageNamed:imgName];
    return [image resizableImageWithCapInsets:capInsets];
}

#pragma mark - 图片圆角处理
- (UIImage *)maskRadius:(CGFloat)radius {
    if (radius <= 0.f) return self;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    if (width <= 0.f || height <= 0.f) return self;
    CGFloat _radius = MIN(width, height)/2.f;
    radius = MIN(_radius, radius);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0.f, 0.f, width, height);
    
    CGContextBeginPath(context);
    
    CGFloat fw, fh;
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, radius, radius);
    fw = CGRectGetWidth(rect)/radius;
    fh = CGRectGetHeight(rect)/radius;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    
    CGContextClosePath(context);
    
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    return image;
}

void UIImageMaskRadius (UIImage **img, CGFloat radius) {
    UIImage *image = [(*img) maskRadius:radius];
    *img = image;
}

#pragma mark - 压缩图片至指定像素
- (UIImage *)resizingToPix:(CGFloat )pix {
    if (pix <= 0.f) return self;
    CGSize size = self.size;
    size = CGSizeMake(size.width*self.scale, size.height*self.scale);
    if (size.width <= 0.f || size.height <= 0.f) return self;
    if (size.width <= pix && size.height <= pix) return self;
    CGFloat scale = size.width/size.height;
    if (size.width > size.height) {
        size.width = pix;
        size.height = size.width/scale;
    } else {
        size.height = pix;
        size.width = size.height*scale;
    }
    return [self resizingToSize:size];
}

#pragma mark - 压缩图片至指定尺寸
- (UIImage *)resizingToSize:(CGSize)size {
    if (size.width <= 0.f || size.height <= 0.f) return nil;
    size.width = floor(size.width);
    size.height = floor(size.height);
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 截取当前image对象rect区域内的图像
- (UIImage *)cropImageInRect:(CGRect)rect {
    rect.origin.x = floor(rect.origin.x);
    rect.origin.y = floor(rect.origin.y);
    rect.size.width = floor(rect.size.width);
    rect.size.height = floor(rect.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)imageByCropToRect:(CGRect)rect {
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    if (rect.size.width <= 0.f || rect.size.height <= 0.f) return nil;
    rect.origin.x = floor(rect.origin.x);
    rect.origin.y = floor(rect.origin.y);
    rect.size.width = floor(rect.size.width);
    rect.size.height = floor(rect.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

#pragma mark - 获得灰度图
- (UIImage *)grayImage {
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) return nil;
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}

#pragma mark - 纠正图片的方向
- (UIImage *)resizingOrientation {
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

- (UIImage *)normalOrientationImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 按给定的方向旋转图片
- (UIImage*)rotateToOrientation:(UIImageOrientation)orient {
    CGRect bnds = CGRectZero;
    UIImage* copy = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = self.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    
    rect.size.width = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return self;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = CGRectChangeWidthHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = CGRectChangeWidthHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = CGRectChangeWidthHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = CGRectChangeWidthHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            return self;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

#pragma mark - 交换宽高
static CGRect CGRectChangeWidthHeight(CGRect rect) {
    CGFloat swap = rect.size.width;
    rect.size.width = rect.size.height;
    rect.size.height = swap;
    return rect;
}

#pragma mark - 垂直翻转
- (UIImage *)flipVertical {
    return [self rotateToOrientation:UIImageOrientationDownMirrored];
}

#pragma mark - 水平翻转
- (UIImage *)flipHorizontal {
    return [self rotateToOrientation:UIImageOrientationUpMirrored];
}

#pragma mark - 将图片旋转指定弧度
- (UIImage *)rotateToRadians:(CGFloat)radians {
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2.0, rotatedSize.height/2.0);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.f, -1.f);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width/2.f, -self.size.height/2.f, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 将图片旋转角度
- (UIImage *)rotateToDegrees:(CGFloat)degrees {
    return [self rotateToRadians:(M_PI*(degrees )/180.f)];
}

#pragma mark - 指定大小生成一个平铺的图片
- (UIImage *)imageWithTiledSize:(CGSize)size {
    UIView *tempView = [[UIView alloc] init];
    tempView.bounds = (CGRect){CGPointZero, size};
    tempView.backgroundColor = [UIColor colorWithPatternImage:self];
    UIGraphicsBeginImageContext(size);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 将两个图片生成一张图片
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    CGImageRef firstImageRef = firstImage.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    CGImageRef secondImageRef = secondImage.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    [firstImage drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithMergeImage:(UIImage *)image {
    return [UIImage mergeImage:self withImage:image];
}

- (UIImage *)wzm_getGrayImage {
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}

+ (NSMutableArray *)wzm_getImagesByUrl:(NSURL *)url count:(NSInteger)count original:(BOOL)original {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *AVAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    NSMutableArray *keyImages = [[NSMutableArray alloc] initWithCapacity:0];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:AVAsset];
    generator.appliesPreferredTrackTransform = YES;
    if (original == NO) {
        generator.maximumSize = CGSizeMake(300,300);
    }
    for (NSInteger i = 0; i < count; i ++) {
        CGFloat progress = i*1.0/count;
        CMTime dur = AVAsset.duration;
        CMTime time = CMTimeMultiplyByFloat64(dur, progress);
        CGImageRef img = [generator copyCGImageAtTime:time actualTime:NULL error:nil];
        UIImage *image = [UIImage imageWithCGImage:img];
        CGImageRelease(img);
        [keyImages addObject:image];
    }
    return keyImages;
}

+ (UIImage *)wzm_getImageByUrl:(NSURL *)url progress:(CGFloat)progress original:(BOOL)original {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *AVAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:AVAsset];
    generator.appliesPreferredTrackTransform = YES;
    if (original == NO) {
        generator.maximumSize = CGSizeMake(300,300);
    }
    CMTime dur = AVAsset.duration;
    CMTime time = CMTimeMultiplyByFloat64(dur, progress);
    CGImageRef img = [generator copyCGImageAtTime:time actualTime:NULL error:nil];
    UIImage *image = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    return image;
}

+ (UIImage *)wzm_getImageByImages:(NSArray<UIImage *> *)images type:(NSInteger)type {
    UIImage *fImage = images.firstObject;
    if (type == 0) {
        //横向
        CGSize size = CGSizeMake(fImage.size.width*images.count, fImage.size.height);
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        for (NSInteger i = 0; i < images.count; i ++) {
            UIImage *image = [images objectAtIndex:i];
            [image drawInRect:CGRectMake(i*fImage.size.width, 0, fImage.size.width, fImage.size.height)];
        }
    }
    else {
        //纵向
        CGSize size = CGSizeMake(fImage.size.width, fImage.size.height*images.count);
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        for (NSInteger i = 0; i < images.count; i ++) {
            UIImage *image = [images objectAtIndex:i];
            [image drawInRect:CGRectMake(0, i*fImage.size.height, fImage.size.width, fImage.size.height)];
        }
    }
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
