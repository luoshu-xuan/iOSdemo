//
//  ViewController.m
//  声音播放器
//
//  Created by 尹键溶 on 2017/7/17.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "ViewController.h"
#import "AudioModel.h"
#import "AudioView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个view的视图
    AudioView *audioView = [[[NSBundle mainBundle]loadNibNamed:@"Empty" owner:self options:nil] lastObject];
    
    //创建数组，里面存放的是字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@"amazarashi" forKey:@"singerName"];
    [dict setValue:@"夏を待っていました " forKey:@"audioName"];
    
    AudioModel *model1 = [[AudioModel alloc] initWithDict:dict];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    
    [dict1 setValue:@"三无" forKey:@"singerName"];
    [dict1 setValue:@"牛奶香槟" forKey:@"audioName"];
    AudioModel *model2 = [[AudioModel alloc] initWithDict:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    
    [dict2 setValue:@"三无1" forKey:@"singerName"];
    [dict2 setValue:@"干物女" forKey:@"audioName"];
    
    AudioModel *model3 = [[AudioModel alloc] initWithDict:dict2];
    //创建模型数组
    NSArray *musicList = @[model1,model2,model3];
    //把模型数组赋给view的数组
    audioView.MusList =musicList;
    [self.view addSubview:audioView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
