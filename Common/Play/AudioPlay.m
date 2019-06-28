//
//  AudioPlay.m
//  lame
//
//  Created by Enjoy on 2019/6/28.
//  Copyright © 2019 MAC. All rights reserved.
//

#import "AudioPlay.h"
#import "GTMBase64.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlay()

@property (nonatomic ,strong) AVAudioEngine *audioEngine;
@end

@implementation AudioPlay

- (instancetype)init {
    self = [super init];
    if (self) {
        self.audioEngine = [[AVAudioEngine alloc] init];
    }
    return self;
}

- (void)playSourceFile {
    AVAudioPlayerNode *player = [[AVAudioPlayerNode alloc] init];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"B" withExtension:@"mp3"];
    NSError *error;
    AVAudioFile *file = [[AVAudioFile alloc] initForReading:url error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    [self.audioEngine attachNode:player];
    [self.audioEngine connect:player to:self.audioEngine.mainMixerNode format:file.processingFormat];
    [player scheduleFile:file atTime:nil completionHandler:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.audioEngine.isRunning) {
                [self.audioEngine stop];
            }
        });
        
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [player play];
}

- (void)playSourceBuffer {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"B" withExtension:@"mp3"];
    NSError *error;
    AVAudioFile *file = [[AVAudioFile alloc] initForReading:url error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:file.processingFormat frameCapacity:(AVAudioFrameCount)(file.length)];
    [file readIntoBuffer:buffer error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    AVAudioPlayerNode *player = [[AVAudioPlayerNode alloc] init];
    [self.audioEngine attachNode:player];
    AVAudioFormat *format = [self.audioEngine.mainMixerNode outputFormatForBus:0];
    [self.audioEngine connect:player to:self.audioEngine.mainMixerNode format:format];
    
    [player scheduleBuffer:buffer completionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.audioEngine.isRunning) {
                [self.audioEngine stop];
            }
        });
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [player play];
}

- (void)playSourceBufferLoop {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"B" withExtension:@"mp3"];
    NSError *error;
    AVAudioFile *file = [[AVAudioFile alloc] initForReading:url error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:file.processingFormat frameCapacity:(AVAudioFrameCount)(file.length)];
    [file readIntoBuffer:buffer error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    AVAudioPlayerNode *player = [[AVAudioPlayerNode alloc] init];
    [self.audioEngine attachNode:player];
    AVAudioFormat *format = [self.audioEngine.mainMixerNode outputFormatForBus:0];
    [self.audioEngine connect:player to:self.audioEngine.mainMixerNode format:format];
    
    [player scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionCallbackType:AVAudioPlayerNodeCompletionDataPlayedBack completionHandler:^(AVAudioPlayerNodeCompletionCallbackType callbackType) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.audioEngine.isRunning) {
                [self.audioEngine stop];
            }
        });
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [player play];
}

- (void)playStringBuffer {
    
    AVAudioPCMBuffer *buffer = [self getBuffer];
    if (buffer == nil) {
        return;
    }
    
    AVAudioPlayerNode *player = [[AVAudioPlayerNode alloc] init];
    
    [self.audioEngine attachNode:player];
    
    AVAudioFormat *outPutFormat = [self.audioEngine.mainMixerNode outputFormatForBus:0];
    
    [self.audioEngine connect:player to:self.audioEngine.mainMixerNode format:outPutFormat];

    [player scheduleBuffer:buffer completionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.audioEngine.isRunning) {
                [self.audioEngine stop];
            }
        });
    }];

    [self.audioEngine prepare];
    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }

    [player play];
}



/**
 *   AVAudioTime 可以进行时长的设置(自己玩)
 *   AVAudioPlayerNodeBufferLoops 循环播放
 *   AVAudioPlayerNodeCompletionDataPlayedBack 后台播放(大喇叭)
 */
- (void)playStringBufferLoop {
    
    AVAudioPCMBuffer *buffer = [self getBuffer];
    if (buffer == nil) {
        return;
    }
    
    AVAudioPlayerNode *player = [[AVAudioPlayerNode alloc] init];
    
    [self.audioEngine attachNode:player];
    
    AVAudioFormat *outPutFormat = [self.audioEngine.mainMixerNode outputFormatForBus:0];
    
    [self.audioEngine connect:player to:self.audioEngine.mainMixerNode format:outPutFormat];
    
    [player scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionCallbackType:AVAudioPlayerNodeCompletionDataPlayedBack completionHandler:^(AVAudioPlayerNodeCompletionCallbackType callbackType) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.audioEngine.isRunning) {
                [self.audioEngine stop];
            }
        });
    }];
    
    [self.audioEngine prepare];
    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [player play];
}

- (void)dealloc {
    
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
    }
    self.audioEngine = nil;
}



#pragma mark - Buffer

- (AVAudioPCMBuffer *)getBuffer {
    
    // 使用系统的Base64转换, 得到的nil? 不知道为啥?
    // NSData *pcmData = [[NSData alloc] initWithBase64EncodedString:MP3StringA options:0];
    // 使用GTMBase64转换ok
    NSData *pcmData = [GTMBase64 decodeString:MP3StringA];
    
    AVAudioFormat *format = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatInt16 sampleRate:8000 channels:2 interleaved:NO];
    
    UInt32 mBytesPerFrame = format.streamDescription->mBytesPerFrame;
    
    NSLog(@"mBytesPerFrame: %d   pcm length: %ld", mBytesPerFrame, pcmData.length);
    
    int frameCapacity = (UInt32)pcmData.length / format.streamDescription->mBytesPerFrame;
    
    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:format frameCapacity:frameCapacity];
    
    buffer.frameLength = buffer.frameCapacity;
    
    [pcmData getBytes:*buffer.int16ChannelData length:pcmData.length];
    
    return buffer;
}
/*
 guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCapacity) else { return nil }
 buffer.frameLength = buffer.frameCapacity
 
 let audioBuffer = buffer.audioBufferList.pointee.mBuffers
 withUnsafeBytes { addr in
 audioBuffer.mData?.copyMemory(from: addr, byteCount: Int(audioBuffer.mDataByteSize))
 }

 */

@end


/** 参考资料:
 *  https://www.jianshu.com/p/506c62183763
 *  https://stackoverflow.com/questions/55306996/playing-wav-data-with-avaudioengine?noredirect=1
 */
