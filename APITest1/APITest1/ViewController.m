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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)CreateMusicModel:(NSDictionary*)dic{
//    NSLog(@"%@",dic);
    //开始构造model
    MusicModel *MusicData = [MusicModel musicDataWithDic:dic];
    //歌手名
    _Singer.text = MusicData.SingerName;
    //歌名
    _SingName.text = MusicData.MusicName;
    NSLog(@"已经得到dic开始进行model的赋值了：%@,%@",self.Singer.text,self.SingName.text);
    //图片，需要进行网络请求
    NSString *ImageURL = [NSString stringWithFormat:@"%@", MusicData.ImageURL];
    //制作URL
    NSURL *URL = [NSURL URLWithString:ImageURL];
    //简单进行网络请求
    [[[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        NSLog(@"这是第二次请求图片地址的请求，%@,%@",self.Singer.text,self.SingName.text);
        if(error){
            NSLog(@"图片加载出错！");
        }else{
            self.SingImage.image = [UIImage imageWithData:data];
        }
    }] resume];

}

-(void)DataToDic:(NSString *)MyMus{

    [FetchDateFromIE fetchMusicData:MyMus WithBack:^(NSData *data, NSURLResponse *response) {
//        NSLog(@"成功了！");
//        NSLog(@"成功回调！");
        NSLog(@"vc刚刚发送第一次网络请求");
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
        NSDictionary *Dict = [NSDictionary dictionary];
        //目前要求只取出第一个的信息就可以了
        Dict = [NSDictionary dictionaryWithDictionary:array[0]];
        //创建MusicModel
        [self CreateMusicModel:Dict];
        NSLog(@"已经创建好model了：%@,%@",self.Singer.text,self.SingName.text);

    }];
    
}
-(void)testDidChange:(UITextField *)sender{
    if(sender.editing == YES) self.Music = sender.text;
}

-(void)setTextFiled:(UITextField *)TextFiled{
    [TextFiled addTarget:self action:@selector(testDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

//记录输入的并且将其赋给自己的MusicName

- (IBAction)Search:(id)sender {
    [self DataToDic:self.Music];
    NSLog(@"应该全部结束了：%@,%@",self.SingName.text,self.Singer.text);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
