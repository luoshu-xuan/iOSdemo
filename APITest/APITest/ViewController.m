//
//  ViewController.m
//  APITest
//
//  Created by 尹键溶 on 2017/9/26.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "ViewController.h"
#import "FetchDateFromIE.h"
#import "MusicModel.h"
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *Serach;
@property (weak, nonatomic) IBOutlet UITextField *TextFiled;
@property (weak, nonatomic) IBOutlet __block UILabel *SingName;
@property (weak, nonatomic) IBOutlet __block UILabel *Singer;
@property (weak, nonatomic) IBOutlet __block UIImageView *SingImage;

@property (nonatomic,strong) NSString* Music;
@property (nonatomic,strong) NSString* __block MusicURL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//-(void)CreateMusicModel:(NSDictionary*)dic{
//    NSLog(@"%@",dic);
//    //开始构造model
//    MusicModel *MusicData = [MusicModel musicDataWithDic:dic];
//    //歌手名
//    _Singer.text = MusicData.SingerName;
//    //歌名
//    _SingName.text = MusicData.MusicName;
//    NSLog(@"已经得到dic开始进行model的赋值了：%@,%@",self.Singer.text,self.SingName.text);
    //图片，需要进行网络请求
//    NSString *ImageURL = [NSString stringWithFormat:@"%@", MusicData.ImageURL];
//    //制作URL
//    NSURL *URL = [NSURL URLWithString:ImageURL];
//    //简单进行网络请求
//    [[[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        //
//        NSLog(@"这是第二次请求图片地址的请求，%@,%@",self.Singer.text,self.SingName.text);
//        if(error){
//            NSLog(@"图片加载出错！");
//        }else{
//            self.SingImage.image = [UIImage imageWithData:data];
//        }
//    }] resume];

//}

//-(MusicModel *)DataToDic:(NSString *)MyMus{
//    __block MusicModel *Music = [[MusicModel alloc]init];
//    [FetchDateFromIE fetchMusicData:MyMus WithBack:^(NSData *data, NSURLResponse *response) {
////        NSLog(@"成功了！");
////        NSLog(@"成功回调！");
//        //创建一个可变数组，用来存放解析后的消息
//        NSMutableArray *array = [NSMutableArray array];
//        //创建一个字典用来存储json格式解析后的数据
//        NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        //取出里面的歌曲json信息
//        itemDictionary = [[[itemDictionary objectForKey:@"result"] objectForKey:@"song_info"] objectForKey:@"song_list"];
//        //将字典对象存到数组
//        for (NSDictionary *dic in itemDictionary) {
//            [array addObject:dic];
//        }
//        //创建一个字典，用来存放第一组数据
//        NSDictionary *Dict = [NSDictionary dictionaryWithDictionary:array[0]];
//        Music = [MusicModel musicDataWithDic:Dict];
//        NSLog(@"1模型进行网络请求");
//    }];
//    return Music;
//    
//}
-(void)testDidChange:(UITextField *)sender{
    if(sender.editing == YES) self.Music = sender.text;
}

-(void)setTextFiled:(UITextField *)TextFiled{
    [TextFiled addTarget:self action:@selector(testDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

//记录输入的并且将其赋给自己的MusicName

- (IBAction)Search:(id)sender {
    //创建模型接收
    __block MusicModel *Music = [[MusicModel alloc]init];
    //信号量
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建一个全局并行队列
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    //创建任务
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        __block MusicModel *Music = [[MusicModel alloc]init];
        [FetchDateFromIE fetchMusicData:self.Music WithBack:^(NSData *data, NSURLResponse *response) {
            //        NSLog(@"成功了！");
            //        NSLog(@"成功回调！");
            //创建一个可变数组，用来存放解析后的消息
            NSMutableArray *array = [NSMutableArray array];
            //创建一个字典用来存储json格式解析后的数据
            NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //取出里面的歌曲json信息
            itemDictionary = [[[itemDictionary objectForKey:@"result"] objectForKey:@"song_info"] objectForKey:@"song_list"];
            //将字典对象存到数组
            for (NSDictionary *dic in itemDictionary) {
                [array addObject:dic];
            }
            //创建一个字典，用来存放第一组数据
            NSDictionary *Dict = [NSDictionary dictionaryWithDictionary:array[0]];
            Music = [MusicModel musicDataWithDic:Dict];
            //歌手名
            self.Singer.text = Music.SingerName;
            //歌名
            self.SingName.text = Music.MusicName;
            self.MusicURL = Music.ImageURL;
            NSLog(@"1模型进行网络请求");
            dispatch_group_leave(group);
        
        }];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_async(group,queue , ^{
        NSURL *URL = [NSURL URLWithString:self.MusicURL];
        //简单进行网络请求
        [[[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //
            if(error){
                NSLog(@"图片加载出错！");
            }else{
                self.SingImage.image = [UIImage imageWithData:data];
                NSLog(@"2图片进行网络请求");
            }
        }] resume];

    });
    
    //开始执行获取字典，构建模型，返回模型
//    dispatch_async(queue, ^{
//        Music = [self DataToDic:self.Music];
//        });
    //开始进行图片的网络请求
//    dispatch_async(queue, ^{
//        NSURL *URL = [NSURL URLWithString:Music.ImageURL];
//        //简单进行网络请求
//        [[[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            //
//            if(error){
//                NSLog(@"图片加载出错！");
//            }else{
//                self.SingImage.image = [UIImage imageWithData:data];
//            }
//        }] resume];
//        
//    });

//    //信号等待
//    dispatch_group_notify(group, queue, ^{
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
