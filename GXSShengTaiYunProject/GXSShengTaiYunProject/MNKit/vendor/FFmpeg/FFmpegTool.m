//
//  FFmpegKit.m
//  ZiMuKing
//
//  Created by Vincent on 2019/12/5.
//  Copyright © 2019 Vincent. All rights reserved.
//

#import "FFmpegTool.h"
#import <ffmpegkit/FFmpegKit.h>
#import <ffmpegkit/FFmpegKitConfig.h>

@implementation FFmpegTool
+ (BOOL)checkContentsOfFile:(NSString *)inputPath outputPath:(NSString *)outputPath {
    [NSFileManager.defaultManager removeItemAtPath:outputPath error:nil];
    return ([NSFileManager.defaultManager fileExistsAtPath:inputPath] && [NSFileManager.defaultManager createDirectoryAtPath:outputPath.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:nil]);
}

+ (BOOL)execute:(NSString *)command {
    command = [command stringByReplacingOccurrencesOfString:@"ffmpeg " withString:@""];
    command = [command stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    if (command.length <= 0) return NO;
    
    FFmpegSession *session = [FFmpegKit execute:command];
    BOOL rst = [ReturnCode isSuccess:[session getReturnCode]];
    return rst;
}

+ (void)execute:(NSString *)command completion:(void(^)(BOOL result))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        FFmpegSession *session = [FFmpegKit execute:command];
        if (completion) {
            BOOL rst = [ReturnCode isSuccess:[session getReturnCode]];
            completion(rst);
        }
    });
}

+ (BOOL)exportAudioTrack:(NSString *)videoPath outputPath:(NSString *)outputPath {
    if (![self checkContentsOfFile:videoPath outputPath:outputPath]) return NO;
    NSString *command = [NSString stringWithFormat:@"ffmpeg -i %@ -acodec copy -vn -y %@", videoPath, outputPath];
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
}

+ (void)exportAudioTrack:(NSString *)videoPath outputPath:(NSString *)outputPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool exportAudioTrack:videoPath outputPath:outputPath];
        if (completion) {
            completion(succeed);
        }
    });
}

+ (BOOL)exportVideoTrack:(NSString *)videoPath outputPath:(NSString *)outputPath {
    if (![self checkContentsOfFile:videoPath outputPath:outputPath]) return NO;
    NSString *command = [NSString stringWithFormat:@"ffmpeg -i %@ -vcodec copy -an -y %@", videoPath, outputPath];
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
}

+ (void)exportVideoTrack:(NSString *)videoPath outputPath:(NSString *)outputPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool exportVideoTrack:videoPath outputPath:outputPath];
        if (completion) {
            completion(succeed);
        }
    });
}

+ (BOOL)exportGif:(NSString *)videoPath inRange:(NSRange)range outputPath:(NSString *)outputPath {
    if (![self checkContentsOfFile:videoPath outputPath:outputPath]) return NO;
    NSString *command = (range.length == 0) ? [NSString stringWithFormat:@"ffmpeg -i %@ -f gif -y %@", videoPath, outputPath] : [NSString stringWithFormat:@"ffmpeg -i %@ -ss %@ -t %@ -f gif -y %@", videoPath, @(range.location), @(range.length), outputPath];
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
}

+ (void)exportGif:(NSString *)videoPath inRange:(NSRange)range outputPath:(NSString *)outputPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool exportGif:videoPath inRange:range outputPath:outputPath];
        if (completion) {
            completion(succeed);
        }
    });
}

+ (BOOL)convertM4a:(NSString *)m4aPath toWav:(NSString *)wavPath {
    if (![self checkContentsOfFile:m4aPath outputPath:wavPath]) return NO;
    NSString *command = [NSString stringWithFormat:@"ffmpeg -i %@ -acodec pcm_s16le -ac 1 -ar 16000 -y %@", m4aPath, wavPath];
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:wavPath]);
}

+ (void)convertM4a:(NSString *)m4aPath toWav:(NSString *)wavPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool convertM4a:m4aPath toWav:wavPath];
        if (completion) {
            completion(succeed);
        }
    });
}

+ (BOOL)convertMp3:(NSString *)mp3Path toWav:(NSString *)wavPath {
    if (![self checkContentsOfFile:mp3Path outputPath:wavPath]) return NO;
    NSString *command = [NSString stringWithFormat:@"ffmpeg -i %@ -acodec pcm_s16le -ac 1 -ar 16000 -y %@", mp3Path, wavPath];
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:wavPath]);
}

+ (void)convertMp3:(NSString *)mp3Path toWav:(NSString *)wavPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool convertMp3:mp3Path toWav:wavPath];
        if (completion) {
            completion(succeed);
        }
    });
}

+ (BOOL)cutVideo:(NSString *)videoPath withRange:(NSRange)range outputPath:(NSString *)outputPath {
    if (![self checkContentsOfFile:videoPath outputPath:outputPath]) return NO;
    //ffmpeg -ss [start] -t [duration] -i [in].mp4  -c:v libx264 -c:a aac -strict experimental -b:a 98k [out].mp4
    NSString *command = [NSString stringWithFormat:@"ffmpeg -ss %@ -t %@ -i %@ -c:v libx264 -c:a aac -strict experimental -b:a 98k -y %@", @(range.location), @(range.length), videoPath, outputPath];
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
}

+ (void)cutVideo:(NSString *)videoPath withRange:(NSRange)range outputPath:(NSString *)outputPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool cutVideo:videoPath withRange:range outputPath:outputPath];
        if (completion) {
            completion(succeed);
        }
    });
}

+ (BOOL)cutVideo:(NSString *)videoPath beginTime:(CGFloat)begin duration:(CGFloat)duration outputPath:(NSString *)outputPath {
    if (![self checkContentsOfFile:videoPath outputPath:outputPath]) return NO;
    NSString *command = [NSString stringWithFormat:@"ffmpeg -i %@ -ss %@ -t %@ -codec copy -y %@", videoPath, @(begin), @(duration), outputPath];
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
}

+ (void)cutVideo:(NSString *)videoPath beginTime:(CGFloat)begin duration:(CGFloat)duration outputPath:(NSString *)outputPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool cutVideo:videoPath beginTime:begin duration:duration outputPath:outputPath];
        if (completion) {
            completion(succeed);
        }
    });
}

+ (BOOL)cropVideo:(NSString *)videoPath withFrame:(CGRect)frame outputPath:(NSString *)outputPath {
    if (![self checkContentsOfFile:videoPath outputPath:outputPath]) return NO;
    //crop=width:height:x:y, 其中width和height 表示裁剪后的尺寸, x:y 表示裁剪区域的左上角坐标
    NSString *command = [NSString stringWithFormat:@"ffmpeg -i %@ -strict -2 -vf crop=%@:%@:%@:%@ -y %@", videoPath, @(frame.size.width), @(frame.size.height), @(frame.origin.x), @(frame.origin.y), outputPath];
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
}

+ (void)cropVideo:(NSString *)videoPath withFrame:(CGRect)frame outputPath:(NSString *)outputPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool cropVideo:videoPath withFrame:frame outputPath:outputPath];
        if (completion) {
            completion(succeed);
        }
    });
}

+ (BOOL)exportThumbnail:(NSString *)videoPath atTime:(CGFloat)time size:(CGSize)size outputPath:(NSString *)outputPath {
    if (![self checkContentsOfFile:videoPath outputPath:outputPath]) return NO;
    NSInteger width = size.width;
    NSInteger height = size.height;
    size.width = width;
    size.height = height;
    NSString *format = [videoPath.pathExtension isEqualToString:@"flv"] ? @"mjpeg" : @"image2";
    NSString *command = [NSString stringWithFormat:@"ffmpeg -ss %@ -i %@ -f %@ -s %@x%@ -y %@", @(time), videoPath, format, @(size.width), @(size.height), outputPath];
    if (size.width <= 0.f || size.height <= 0.f) {
        command = [NSString stringWithFormat:@"ffmpeg -ss %@ -i %@ -f %@ -vframes 1 -y %@", @(time), videoPath, format, outputPath];
    }
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
}

+ (void)exportThumbnail:(NSString *)videoPath atTime:(CGFloat)time size:(CGSize)size outputPath:(NSString *)outputPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool exportThumbnail:videoPath atTime:time size:size outputPath:outputPath];
        if (completion) {
            completion(succeed);
        }
    });
}

+ (BOOL)exportWithoutWatermark:(NSString *)videoPath rect:(CGRect)rect outputPath:(NSString *)outputPath {
    if (![self checkContentsOfFile:videoPath outputPath:outputPath]) return NO;
    NSInteger x = floor(rect.origin.x);
    NSInteger y = floor(rect.origin.y);
    NSInteger w = floor(rect.size.width);
    NSInteger h = floor(rect.size.height);
    NSString *command = [NSString stringWithFormat:@"-i %@ -vf delogo=x=%@:y=%@:w=%@:h=%@ %@", videoPath, @(x), @(y), @(w), @(h), outputPath];
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
}

+ (void)exportWithoutWatermark:(NSString *)videoPath rect:(CGRect)rect outputPath:(NSString *)outputPath completion:(void(^)(BOOL succeed))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool exportWithoutWatermark:videoPath rect:rect outputPath:outputPath];
        if (completion) {
            completion(succeed);
        }
    });
}


/**
 视频水印模糊--批量处理
 @param videoPath 视频路径
 @param rectArr 水印位置Arr
 @param outputPath 输出路径
 @return 执行结果
 */
+ (BOOL)exportWithoutWatermark:(NSString *)videoPath rectArr:(NSMutableArray *)rectArr outputPath:(NSString *)outputPath
{
    if (![self checkContentsOfFile:videoPath outputPath:outputPath]) return NO;
//    ffmpeg.exe -i "D:\Down\iPandaCUT.mp4" -vf "delogo=x=49:y=50:w=221:h=75,delogo=x=1014:y=678:w=234:h=35" -c:a copy "D:\Down\new.mp4"
    
    NSString *delogoStr = @"";
    for (NSInteger i=0; i<rectArr.count; i++) {
        NSValue *tmpValue = rectArr[i];
        CGRect rect = [tmpValue CGRectValue];
        
        NSInteger x = floor(rect.origin.x);
        NSInteger y = floor(rect.origin.y);
        NSInteger w = floor(rect.size.width);
        NSInteger h = floor(rect.size.height);
        
        NSString *tempStr = [NSString stringWithFormat:@"delogo=x=%@:y=%@:w=%@:h=%@",@(x), @(y), @(w), @(h)];
        if (i==0) {
            delogoStr = tempStr;
        }else
        {
            delogoStr = [NSString stringWithFormat:@"%@,%@",delogoStr,tempStr];
        }
        
    }
//    NSString *command = [NSString stringWithFormat:@"-i %@ -vf delogo=x=%@:y=%@:w=%@:h=%@ %@", videoPath, @(x), @(y), @(w), @(h), outputPath];
    NSString *command = [NSString stringWithFormat:@"ffmpeg -i %@ -vf %@ %@", videoPath, delogoStr, outputPath];
    NSLog(@"---批量处理的指令=%@",command);
    return ([self execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
//    return ([FFmpegKit execute:command] && [NSFileManager.defaultManager fileExistsAtPath:outputPath]);
}
/**
 视频水印模糊分线程>--批量处理
 @param videoPath 视频路径
 @param rectArr 水印位置Arr
 @param outputPath 输出路径
 @param completion 执行结果
 */
+ (void)exportWithoutWatermark:(NSString *)videoPath rectArr:(NSMutableArray *)rectArr outputPath:(NSString *)outputPath completion:(void(^)(BOOL succeed))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL succeed = [FFmpegTool exportWithoutWatermark:videoPath rectArr:rectArr outputPath:outputPath];
        if (completion) {
            completion(succeed);
        }
    });
}

@end
