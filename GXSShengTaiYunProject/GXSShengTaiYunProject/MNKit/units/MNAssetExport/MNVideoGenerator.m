//
//  MNVideoGenerator.m
//  MNKit
//
//  Created by Vicent on 2020/8/6.
//

#import "MNVideoGenerator.h"
#if __has_include(<AVFoundation/AVFoundation.h>)
#import <AVFoundation/AVFoundation.h>

@interface MNVideoGenerator ()
@property (nonatomic) float progress;
@property (nonatomic, copy) NSError *error;
@property (nonatomic) MNVideoGenerateStatus status;
@property (nonatomic, strong) AVAssetWriterInput *videoInput;
@property (nonatomic, strong) NSMutableDictionary <NSValue *, UIImage *>*imageAdaptor;
@property (nonatomic, copy) MNVideoGenerateProgressHandler progressHandler;
@property (nonatomic, copy) MNVideoGenerateCompletionHandler completionHandler;
@end

@implementation MNVideoGenerator

- (instancetype)init {
    if (self = [super init]) {
        self.frameRate = 30;
        self.imageAdaptor = @{}.mutableCopy;
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *>*)images {
    return [self initWithImages:images duration:0.f];
}

- (instancetype)initWithImages:(NSArray <UIImage *>*)images duration:(NSTimeInterval)duration {
    if (self = [super init]) {
        self.images = images;
        self.duration = duration;
    }
    return self;
}

- (void)appendImage:(UIImage *)image atRect:(CGRect)imageRect {
    if (self.status == MNVideoGenerateStatusExporting || !image) return;
    [self.imageAdaptor setObject:image forKey:[NSValue valueWithCGRect:imageRect]];
}

- (void)appendImage:(UIImage *)image atPoint:(CGPoint)imagePoint {
    if (self.status == MNVideoGenerateStatusExporting || !image) return;
    CGSize imageSize = CGSizeMake(image.size.width*image.scale, image.size.height*image.scale);
    [self appendImage:image atRect:(CGRect){imagePoint, imageSize}];
}

- (void)exportAsynchronouslyWithCompletionHandler:(MNVideoGenerateCompletionHandler)completionHandler {
    [self exportAsynchronouslyWithProgressHandler:nil completionHandler:completionHandler];
}

- (void)exportAsynchronouslyWithProgressHandler:(MNVideoGenerateProgressHandler)progressHandler
                              completionHandler:(MNVideoGenerateCompletionHandler)completionHandler
{
    if (self.status == MNVideoGenerateStatusExporting) return;
    self.error = nil;
    _progress = 0.f;
    self.status = MNVideoGenerateStatusExporting;
    self.progressHandler = progressHandler;
    self.completionHandler = completionHandler;
    dispatch_queue_t queue = dispatch_queue_create("com.mn.video.generate.export.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self exporting];
    });
}

- (void)exporting {
    
    // ????????????
    __block NSError *error;
    NSString *outputPath = self.outputPath;
    
    // ??????????????????
    if ([NSFileManager.defaultManager fileExistsAtPath:outputPath]) [NSFileManager.defaultManager removeItemAtPath:outputPath error:nil];
    if (outputPath.length <= 0 || ![NSFileManager.defaultManager createDirectoryAtPath:[outputPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error]) {
        if (!error) error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotCreateFile userInfo:@{NSLocalizedDescriptionKey:@"??????????????????"}];
        [self finishExportWithError:error];
        return;
    }
    
    // ??????????????????
    if (self.duration <= 0.f) {
        NSError *error = [NSError errorWithDomain:AVFoundationErrorDomain
                                             code:AVErrorExportFailed
                                         userInfo:@{NSLocalizedDescriptionKey:@"?????????????????????"}];
        [self finishExportWithError:error];
        return;
    }
    
    // ??????????????????
    if (self.images.count <= 0) {
        NSError *error = [NSError errorWithDomain:AVFoundationErrorDomain
                                             code:AVErrorNoImageAtTime
                                         userInfo:@{NSLocalizedDescriptionKey:@"??????????????????"}];
        [self finishExportWithError:error];
        return;
    }
    CGSize renderSize = self.renderSize;
    UIImage *firstImage = [self resizingImageOrientation:self.images.firstObject];
    NSInteger width = firstImage.size.width*firstImage.scale;
    NSInteger height = firstImage.size.height*firstImage.scale;
    if (renderSize.width <= 0.f || renderSize.height <= 0.f) renderSize = CGSizeMake(width, height);
    
    // ????????????
    NSArray <UIImage *>*images = [self resizingImageToRenderSize:renderSize];
    // ??????????????? ??????????????????
    self->_images = nil;
    if (!images || images.count <= 0) {
        NSError *error = [NSError errorWithDomain:AVFoundationErrorDomain
                                             code:AVErrorNoImageAtTime
                                         userInfo:@{NSLocalizedDescriptionKey:@"??????????????????"}];
        [self finishExportWithError:error];
        return;
    }

    // ???????????????
    AVAssetWriter *videoWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:outputPath] fileType:AVFileTypeMPEG4 error:&error];
    if (error) {
        [self finishExportWithError:error];
        return;
    }
    
    // ????????????
    NSDictionary *videoSettings = @{AVVideoWidthKey:@(renderSize.width),
                                    AVVideoHeightKey:@(renderSize.height),
                                    AVVideoCodecKey:AVVideoCodecH264,
                                    AVVideoCompressionPropertiesKey:@{AVVideoExpectedSourceFrameRateKey:@(self.frameRate)}};
    
    AVAssetWriterInput *videoInput =[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *pixelBufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey,nil];
    AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoInput sourcePixelBufferAttributes:pixelBufferAttributes];
    
    if (![videoWriter canAddInput:videoInput]) {
        NSError *error = [NSError errorWithDomain:AVFoundationErrorDomain
                                             code:AVErrorExportFailed
                                         userInfo:@{NSLocalizedDescriptionKey:@"????????????????????????"}];
        [self finishExportWithError:error];
        return;
    }
    [videoWriter addInput:videoInput];
    self.videoInput = videoInput;
    
    if (![videoWriter startWriting]) {
        NSError *error = [NSError errorWithDomain:AVFoundationErrorDomain
                                             code:AVErrorExportFailed
                                         userInfo:@{NSLocalizedDescriptionKey:@"????????????????????????"}];
        [self finishExportWithError:error];
        return;
    }
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    // ????????????
    int64_t timescale = (int64_t)self.frameRate;
    // ??????????????????????????????
    int64_t value = (int64_t)(self.duration*timescale);
    // ?????????
    int64_t frames = (int64_t)images.count;
    // ????????????????????????
    int64_t max = [self multiplier:(int64_t)value with:(int64_t)frames];
    // ??????????????????????????????
    timescale = max/value*timescale;
    // ?????????????????????
    CMTime timePerFrame = CMTimeMake(max/frames, (int32_t)timescale);
    // ???????????????
    __block CMTime presentationTime = CMTimeMake(0, (int32_t)timescale);
    
    // ???????????????????????????
    __block int64_t index = 0;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [videoInput requestMediaDataWhenReadyOnQueue:dispatch_queue_create("com.mn.video.export.queue", DISPATCH_QUEUE_SERIAL) usingBlock:^{
        while (self.videoInput.isReadyForMoreMediaData) {
            if (self.status == MNVideoGenerateStatusCancelled) {
                [videoWriter cancelWriting];
                [self.videoInput markAsFinished];
                dispatch_group_leave(group);
                break;
            }
            if (index >= frames) {
                [self.videoInput markAsFinished];
                [videoWriter endSessionAtSourceTime:CMTimeMake(max, (int32_t)timescale)];
                dispatch_group_leave(group);
                break;
            } else {
                UIImage *image = [images objectAtIndex:(NSInteger)index];
                CVPixelBufferRef nextSampleBuffer = [self pixelBufferFromImage:image size:renderSize];
                if (nextSampleBuffer != NULL) {
                    [pixelBufferAdaptor appendPixelBuffer:nextSampleBuffer withPresentationTime:presentationTime];
                    CFRelease(nextSampleBuffer);
                }
                index ++;
                float progress = CMTimeGetSeconds(presentationTime)/(float)self.duration;
                progress = MAX(0.f, MIN(progress, 1.f));
                presentationTime = CMTimeAdd(presentationTime, timePerFrame);
                self.progress = progress;
            }
        }
    }];
    
    // ??????????????????
    dispatch_group_notify(group, dispatch_queue_create("com.mn.video.finish.queue", DISPATCH_QUEUE_SERIAL), ^{
        [videoWriter finishWritingWithCompletionHandler:^{
            if (videoWriter.error) {
                self.error = videoWriter.error;
                if (self.status == MNVideoGenerateStatusExporting) self.status = MNVideoGenerateStatusFailed;
                [NSFileManager.defaultManager removeItemAtPath:outputPath error:nil];
            }
            if (![NSFileManager.defaultManager fileExistsAtPath:outputPath]) {
                if (!self.error) self.error = [NSError errorWithDomain:AVFoundationErrorDomain code:AVErrorExportFailed userInfo:@{NSLocalizedDescriptionKey:@"??????????????????"}];
                if (self.status != MNVideoGenerateStatusCancelled) self.status = MNVideoGenerateStatusFailed;
            } else if (self.status == MNVideoGenerateStatusExporting) {
                self.status = MNVideoGenerateStatusCompleted;
            }
            if (self.status == MNVideoGenerateStatusCancelled || self.status == MNVideoGenerateStatusFailed) {
                [NSFileManager.defaultManager removeItemAtPath:outputPath error:nil];
            }
            if (self.status == MNVideoGenerateStatusCompleted && self.progress < 1.f) self.progress = 1.f;
            if (self.completionHandler) self.completionHandler(self.status, self.error);
        }];
    });
}

- (void)finishExportWithError:(NSError *)error {
    self.error = error;
    if (self.status == MNVideoGenerateStatusExporting) self.status = MNVideoGenerateStatusFailed;
    if (self.completionHandler) self.completionHandler(self.status, self.error);
}

- (void)cancel {
    if (self.status != MNVideoGenerateStatusExporting) return;
    self.status = MNVideoGenerateStatusCancelled;
}

#pragma mark - Tool
// ???????????????????????????
- (NSArray <UIImage *>*)resizingImageToRenderSize:(CGSize)renderSize {
    if (self.images.count <= 0) return nil;
    UIColor *fillColor = self.fillColor ? : UIColor.blackColor;
    NSMutableArray <UIImage *>*images = @[].mutableCopy;
    for (NSInteger idx = 0; idx < self.images.count; idx++) {
        if (self.status == MNVideoGenerateStatusCancelled) {
            [images removeAllObjects];
            break;
        }
        UIImage *image = [self resizingImageOrientation:[self.images objectAtIndex:idx]];
        NSInteger w = image.size.width*image.scale;
        NSInteger h = image.size.height*image.scale;
        CGSize imageSize = CGSizeMake(w, h);
        if (CGSizeEqualToSize(imageSize, renderSize) && self.imageAdaptor.count <= 0) {
            [images addObject:image];
        } else {
            // ??????????????????
            if (renderSize.width >= renderSize.height) {
                // ???????????? ??????????????????
                imageSize.width = imageSize.width/imageSize.height*renderSize.height;
                imageSize.height = renderSize.height;
                if (imageSize.width > renderSize.width) {
                    imageSize.height = imageSize.height/imageSize.width*renderSize.width;
                    imageSize.width = renderSize.width;
                }
            } else {
                // ???????????? ??????????????????
                imageSize.height = imageSize.height/imageSize.width*renderSize.width;
                imageSize.width = renderSize.width;
                if (imageSize.height > renderSize.height) {
                    imageSize.width = imageSize.width/imageSize.height*renderSize.height;
                    imageSize.height = renderSize.height;
                }
            }
            UIGraphicsBeginImageContextWithOptions(renderSize, NO, 1.f);
            [fillColor setFill];
            UIRectFill((CGRect){CGPointZero, renderSize});
            [image drawInRect:CGRectMake((renderSize.width - imageSize.width)/2.f, (renderSize.height - imageSize.height)/2.f, imageSize.width, imageSize.height)];
            [self.imageAdaptor enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
                [obj drawInRect:key.CGRectValue];
            }];
            UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (resizeImage) [images addObject:resizeImage];
        }
    }
    return images.count ? images.copy : nil;
}

// ??????????????????
- (UIImage *)resizingImageOrientation:(UIImage *)image {
    // ??????????????????????????????
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (image.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (image.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0.f, 0.f, image.size.height, image.size.width), image.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0.f, 0.f, image.size.width, image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// ???????????????Buffer
- (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image size:(CGSize)size {
    CGImageRef imageRef = image.CGImage;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                            [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer =NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    if (pxbuffer == NULL || status != kCVReturnSuccess) return NULL;
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    if (pxdata == NULL) return NULL;
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    // ??????????????????????????????, Quartz??????????????????????????????, ????????????????????????; ?????????????????????????????????, Quartz?????????????????????????????????????????????????????????????????????, ???????????????????????????????????????????????????????????????: ?????????????????????, ????????????, alpha??????;
    CGContextRef context = CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    if (context == NULL) return NULL;
    // ??????CGContextDrawImage????????????  ??????????????????????????? ?????????????????????
    // ?????????CGContextDrawImage?????????????????????context??????, ??????????????????UIImage???CGImageRef, ??????UIKit???CG?????????y?????????, ????????????????????????????????????
    CGContextDrawImage(context,CGRectMake(0.f, 0.f, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)),  imageRef);
    // ??????????????????
    CGColorSpaceRelease(rgbColorSpace);
    // ??????context
    CGContextRelease(context);
    // ??????pixel buffer
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}

// ???????????????????????????
- (int64_t)multiplier:(int64_t)a with:(int64_t)b {
    if (a <= 0 || b <= 0) return 0;
    int64_t max = a >= b ? a : b;
    int64_t min = a >= b ? b : a;
    int64_t temp = 0;
    while (min != 0) {
        temp = max%min;
        max = min;
        min = temp;
    }
    return (a*b/max);
}

#pragma mark - Setter
- (void)setFrameRate:(int)frameRate {
    frameRate = MAX(15, MIN(frameRate, 60));
    _frameRate = frameRate;
}

- (void)setRenderSize:(CGSize)renderSize {
    //??????MPEG-2???MPEG-4(???????????????DCT???????????????), ??????????????????16??16?????????????????????, ??????MPEG-4???10??????(AVC/H.264), 4???8????????????????????????, ???16???????????????;
    renderSize.width = floor(ceil(renderSize.width)/16.f)*16.f;
    renderSize.height = floor(ceil(renderSize.height)/16.f)*16.f;
    _renderSize = renderSize;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    if (self.progressHandler) self.progressHandler(progress);
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%@===dealloc", NSStringFromClass(self.class));
}

@end
#endif
