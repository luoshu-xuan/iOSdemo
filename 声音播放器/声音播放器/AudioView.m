//
//  AudioView.m
//  声音播放器
//
//  Created by 尹键溶 on 2017/7/18.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "AudioView.h"
#import "AudioModel.h"
#import <AVFoundation/AVFoundation.h>
@interface AudioView()<AVAudioPlayerDelegate>
//音乐用AvAudio
@property(nonatomic,strong)AVAudioPlayer* mymusic;
//音乐的名称
@property (weak, nonatomic) IBOutlet UILabel *MusicName;
//总共时长
@property (weak, nonatomic) IBOutlet UILabel *MusicTime;
//当前时长
@property (weak, nonatomic) IBOutlet UILabel *NowTime;

//滑动条
@property (weak, nonatomic) IBOutlet UISlider *Slider;


//音乐序号
@property(nonatomic,assign)NSInteger muIndex;
//点击播放
@property (weak, nonatomic) IBOutlet UIButton *ClickPlay;
//那条线
@property (weak, nonatomic) IBOutlet UIImageView *anchorImage;
//判断播放状态
@property(nonatomic,assign,getter=isPlaying)BOOL playing;
//歌手的照片
@property (weak, nonatomic) IBOutlet UIImageView *singerImageView;
//定时器
@property(nonatomic,strong)CADisplayLink *singerTimer;
@end

@implementation AudioView

-(void)setMymusic:(AVAudioPlayer *)mymusic{
    //设置代理
    _mymusic.delegate=self;
}
//加载xib文件时对其进行初始化
-(void)awakeFromNib{
    [super awakeFromNib];
    //让歌手图变成圆形
    self.singerImageView.layer.cornerRadius = 82;
    self.singerImageView.layer.masksToBounds = true;
    //改变其锚点
    self.anchorImage.layer.anchorPoint = CGPointMake(0.21, 0.15);
}

//加载音乐列表
- (void)setMusList:(NSArray *)MusList{
    _MusList = MusList;
    self.muIndex=0;
    //初始化歌手和歌曲都是第一个
    //还要初始化歌名
    [self changeSinger:0];
    [self changeMusic:0];
    [self changeMusicName:0];
}
//加载歌手
- (void)changeSinger:(NSInteger)index{
    //取出歌手
    AudioModel *singer = self.MusList[index];
    //设置歌手图样式
    self.singerImageView.image = [UIImage imageNamed:singer.singerName];
}
//加载歌曲名
-(void)changeMusic:(NSInteger)index{
    //取出歌手
    AudioModel *singer = self.MusList[index];
    //设置歌名
    NSString *musicName = [[NSBundle mainBundle]pathForResource:singer.audioName ofType:@"mp3"];
    //做出URL链接
    NSURL *music = [NSURL fileURLWithPath:musicName];
    //设置歌曲
    _mymusic = [[AVAudioPlayer alloc]initWithContentsOfURL:music error:nil];
    //加载时长
    self.MusicTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)self.mymusic.duration/60,(int)self.mymusic.duration%60];
    
}
//加载歌曲名称
-(void)changeMusicName:(NSInteger)MusicIndex{
    switch (MusicIndex) {
        case 0:
            self.MusicName.text = @"夏を待っていました ";
            break;
        case 1:
            self.MusicName.text = @"牛奶香槟";
            break;
        default:
            self.MusicName.text = @"干物女";
            break;
    }
}

//对于旋转的写法
-(CADisplayLink*)singerTimer{
    if(_singerTimer==nil){
        _singerTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh)];
        //加入主循环
        [_singerTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _singerTimer;
}
//刷新时所需要做的
-(void)refresh{
    //包括照片的旋转
    self.singerImageView.transform = CGAffineTransformRotate(self.singerImageView.transform, M_PI * 2 / 60 /5);
    //还有正在播放的音乐时长
    self.NowTime.text =[NSString stringWithFormat:@"%02d:%02d",(int)self.mymusic.currentTime/60,(int)self.mymusic.currentTime%60];
    //滑动条的位置
    self.Slider.value = self.mymusic.currentTime/self.mymusic.duration;
}


//拖动滑动条所触发的事件
- (void)setSlider:(UISlider *)Slider{
    _Slider = Slider;
    [_Slider addTarget:self action:@selector(ChangeMusicPlayTime) forControlEvents:UIControlEventValueChanged];
}
- (void)ChangeMusicPlayTime{
    //设置此时的秒数
    float fen = self.Slider.value * self.mymusic.duration;
    //左边显示正在拖动的时间
    self.NowTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)fen/60,((int)fen)%60];
    //让音乐也变成现在的时间
   self.mymusic.currentTime = fen;

}
//开始播放时候正在做的事情
-(void)startPlay{
    //状态切换为暂停播放
    self.playing = false;
    //改变图标样式
    //        self.ClickPlay.imageView.image = [UIImage imageNamed:@"cm2_fm_btn_play_prs"];
    UIImage *name = [UIImage imageNamed:@"cm2_fm_btn_play_prs"];
    [_ClickPlay setImage:name forState:UIControlStateNormal];
    //转盘停止旋转 即让定时器停止
    self.singerTimer.paused=true;
    //音乐停止播放
    [self.mymusic pause];
    //锚转回去
    [UIView animateWithDuration:1.0 animations:^{
        self.anchorImage.transform = CGAffineTransformRotate(self.anchorImage.transform, M_PI_4 * 0.4);
    }];

}
//暂停播放的时候正在做的事情
-(void)endPlaying{
    //状态切换为开始播放
    self.playing = true;
    //改变图标样式
    //        self.ClickPlay.imageView.image = [UIImage imageNamed:@"cm2_fm_btn_pause_prs"];
    UIImage *name = [UIImage imageNamed:@"cm2_fm_btn_pause_prs"];
    [_ClickPlay setImage:name forState:UIControlStateNormal];
    //轮盘开始旋转
    self.singerTimer.paused = false;
    //音乐开始播放
    [self.mymusic play];
    //锚转过来
    [UIView animateWithDuration:1.0 animations:^{
        self.anchorImage.transform = CGAffineTransformRotate(self.anchorImage.transform, -M_PI_4 * 0.4);
    }];
}

//点击开始／暂停按键触发事件
- (IBAction)ClickPlaying:(id)sender {
    if(self.isPlaying) [self startPlay];
    else [self endPlaying];
}
//点击上一首触发事件
- (IBAction)ClickPre:(id)sender {
    self.muIndex--;
    if(self.muIndex < 0) self.muIndex = self.MusList.count-1;
    //歌手和歌曲名的刷新
    [self changeSinger:self.muIndex];
    [self changeMusic:self.muIndex];
    [self changeMusicName:self.muIndex];
    //已经播放进度条归0
    self.NowTime.text = @"00:00";
    if(self.isPlaying){
        [self.mymusic play];
    }
    [self ClickPlay];
}
//点击下一首触发事件
- (IBAction)ClickNext{
    self.muIndex++;
    if(self.muIndex >2){
        self.muIndex=0;
    }
    //歌手和歌曲名的刷新
    [self changeSinger:self.muIndex];
    [self changeMusic:self.muIndex];
    [self changeMusicName:self.muIndex];
    //已经播放时间text归0
    self.NowTime.text = @"00:00";
    //滑动条归0
    self.Slider.value=0;
    if(self.isPlaying){
        [self.mymusic play];
    }
    [self ClickPlay];
}
//当一首歌结束的时候使用
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self ClickNext];
}



@end
