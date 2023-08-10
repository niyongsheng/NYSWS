/**
 *  格式支持，播放网络音频缓存为.caf文件
 
 AAC
 AMR(AdaptiveMulti-Rate, aformatforspeech)
 ALAC(AppleLossless)
 iLBC(internetLowBitrateCodec, anotherformatforspeech)
 IMA4(IMA/ADPCM)
 linearPCM(uncompressed)
 µ-lawanda-law
 MP3(MPEG-1audiolayer3
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>  //需要添加AVFoundation.framework

/**
 *  播放器播放文件类型枚举
 */
typedef NS_ENUM(NSUInteger, CKAudioFileTyle) {
    CKAudioFileTyle_Network = 0,  //网络URL
    CKAudioFileTyle_Local,        //本地文件路径
};

/**
 *  声明定义协议
 */
@protocol CKAudioPlayerHelperDelegate <NSObject>

@optional

//开始播放
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer*)audioPlayer;
//停止播放
- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer;
//暂停播放
- (void)didAudioPlayerPausePlay:(AVAudioPlayer*)audioPlayer;
//结束播放
- (void)didAudioPlayerFinishPlay:(AVAudioPlayer*)audioPlayer pathName:(NSString *)pathName;
- (void)didAudioPlayerFinishPlay:(AVAudioPlayer*)audioPlayer serial:(NSString *)serial pathName:(NSString *)pathName;

@end


@interface CKAudioPlayerHelper : NSObject<AVAudioPlayerDelegate>

//第一步：创建声明单例方法
+ (CKAudioPlayerHelper *)shareInstance;

//声明播放器
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

/// 声明文件路径名
@property (nonatomic, copy) NSString *pathName;
/// 序列号
@property (nonatomic, copy) NSString *serial;

//声明协议代理
@property (nonatomic, assign) id <CKAudioPlayerHelperDelegate> delegate;

//网络音频
- (void)managerAudioWithUrlPath:(NSString *)urlPath playOrPause:(BOOL)isPlaying;
- (void)managerAudioWithUrlPath:(NSString *)urlPath serial:(NSString *)serial playOrPause:(BOOL)isPlaying;

//本地音频
- (void)managerAudioWithLocalPath:(NSString *)localPath playOrPause:(BOOL)isPlaying;
- (void)managerAudioWithLocalPath:(NSString *)localPath serial:(NSString *)serial playOrPause:(BOOL)isPlaying;

//暂停播放
- (void)pausePlayingAudio;

//停止播放
- (void)stopAudio;

//删除网络加载缓存文件
- (void)deleteFile;

@end
