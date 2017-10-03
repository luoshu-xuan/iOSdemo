//
//  HomeViewController.m
//  Home
//
//  Created by 尹键溶 on 2017/10/1.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "HomeViewController.h"
#import "HeadImageModel.h"
#import "MyTapGestureRecognizer.h"
#import "MusicCateModel.h"
#import "PlayListModel.h"
#import "MeViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <WebKit/WebKit.h>
@interface HomeViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)__block NSMutableArray *array;
@property(nonatomic,strong)__block UIScrollView *Scro;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    //开始加载
    [self CreateBackGroundImage];
    [self CreateHeadScrollerView];
    [self CreatePlayList];
    [self CreateCategory];
   // [self CreateTarbar]
//    //创建一个全局并行队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //创建一个队列组
//    dispatch_group_t group = dispatch_group_create();
    // Do any additional setup after loading the view.
}
-(void)CreateCategory{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    //热歌榜
    UILabel *Hotlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1650, [UIScreen mainScreen].bounds.size.width/2, 30)];
    Hotlabel.text = @"最热歌曲";
    Hotlabel.textAlignment = NSTextAlignmentLeft;
    Hotlabel.font = [UIFont systemFontOfSize:20];
    Hotlabel.textColor = [UIColor redColor];
    [_Scro addSubview:Hotlabel];
    [manager GET:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&from=qianqianmini&version=11.0.5&platform=darwin&type=2&size=20&offset=0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        dict = [dict objectForKey:@"song_list"];
        //创建一个数组接收模型
        NSArray *array = [MusicCateModel mj_objectArrayWithKeyValuesArray:dict];
        //开始创建label
        for (MusicCateModel *model in array) {
            static int i=1;
            UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1660+i*20, 200, 20)];
            NameLabel.text = [NSString stringWithFormat:@"%d.%@",i,model.title];
            UILabel *SingerLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 1660+i*20, 170, 20)];
            SingerLabel.text = model.author;
            SingerLabel.textAlignment = NSTextAlignmentRight;
            if(i==11) break;
            i++;
            [_Scro addSubview:NameLabel];
            [_Scro addSubview:SingerLabel];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"榜单请求失败 错误：%@",error);
    }];
    //欧美金曲
    UILabel *ForeignLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1900, [UIScreen mainScreen].bounds.size.width/2, 30)];
    ForeignLabel.text = @"欧美金曲";
    ForeignLabel.textAlignment = NSTextAlignmentLeft;
    ForeignLabel.font = [UIFont systemFontOfSize:20];
    ForeignLabel.textColor = [UIColor redColor];
    [_Scro addSubview:ForeignLabel];
    [manager GET:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&from=qianqianmini&version=11.0.5&platform=darwin&type=21&size=20&offset=0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        dict = [dict objectForKey:@"song_list"];
        //创建一个数组接收模型
        NSArray *array = [MusicCateModel mj_objectArrayWithKeyValuesArray:dict];
        //开始创建label
        for (MusicCateModel *model in array) {
            static int i=1;
            UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1910+i*20, 200, 20)];
            NameLabel.text = [NSString stringWithFormat:@"%d.%@",i,model.title];
            //自适应
            NameLabel.adjustsFontSizeToFitWidth = YES;
            NameLabel.numberOfLines = 0;
            UILabel *SingerLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 1910+i*20, 170, 20)];
            SingerLabel.text = model.author;
            SingerLabel.textAlignment = NSTextAlignmentRight;
            //自适应
            SingerLabel.adjustsFontSizeToFitWidth = YES;
            SingerLabel.numberOfLines = 0;
            if(i==11) break;
            i++;
            [_Scro addSubview:NameLabel];
            [_Scro addSubview:SingerLabel];
        }
    //摇滚歌曲
        UILabel *PopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2150, [UIScreen mainScreen].bounds.size.width/2, 30)];
        PopLabel.text = @"摇滚歌曲";
        PopLabel.textAlignment = NSTextAlignmentLeft;
        PopLabel.font = [UIFont systemFontOfSize:20];
        PopLabel.textColor = [UIColor redColor];
        [_Scro addSubview:PopLabel];
        [manager GET:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&from=qianqianmini&version=11.0.5&platform=darwin&type=11&size=20&offset=0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            dict = [dict objectForKey:@"song_list"];
            //创建一个数组接收模型
            NSArray *array = [MusicCateModel mj_objectArrayWithKeyValuesArray:dict];
            //开始创建label
            for (MusicCateModel *model in array) {
                static int i=1;
                UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2160+i*20, 200, 20)];
                NameLabel.text = [NSString stringWithFormat:@"%d.%@",i,model.title];
                UILabel *SingerLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 2160+i*20, 170, 20)];
                SingerLabel.text = model.author;
                SingerLabel.textAlignment = NSTextAlignmentRight;
                if(i==11) break;
                i++;
                [_Scro addSubview:NameLabel];
                [_Scro addSubview:SingerLabel];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"榜单请求失败 错误：%@",error);
        }];
    //原创歌曲
        UILabel *OriginalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2400, [UIScreen mainScreen].bounds.size.width/2, 30)];
        OriginalLabel.text = @"原创歌曲";
        OriginalLabel.textAlignment = NSTextAlignmentLeft;
        OriginalLabel.font = [UIFont systemFontOfSize:20];
        OriginalLabel.textColor = [UIColor redColor];
        [_Scro addSubview:OriginalLabel];
        [manager GET:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&from=qianqianmini&version=11.0.5&platform=darwin&type=11&size=20&offset=0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            dict = [dict objectForKey:@"song_list"];
            //创建一个数组接收模型
            NSArray *array = [MusicCateModel mj_objectArrayWithKeyValuesArray:dict];
            //开始创建label
            for (MusicCateModel *model in array) {
                static int i=1;
                UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2410+i*20, 200, 20)];
                NameLabel.text = [NSString stringWithFormat:@"%d.%@",i,model.title];
                UILabel *SingerLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 2410+i*20, 170, 20)];
                SingerLabel.text = model.author;
                SingerLabel.textAlignment = NSTextAlignmentRight;
                if(i==11) break;
                i++;
                [_Scro addSubview:NameLabel];
                [_Scro addSubview:SingerLabel];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"榜单请求失败 错误：%@",error);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"榜单请求失败 错误：%@",error);
    }];

    
}
-(void)CreateBackGroundImage{
    //背景scrollerview
    UIScrollView *BackImage= [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIImage *image = [UIImage imageNamed:@"timg"];
    [BackImage setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
    //创造一个大的scrollerview
    _Scro= [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //设置可滑动范围
    _Scro.contentSize = CGSizeMake(375, 2750);
    [self.view addSubview:BackImage];
    [BackImage addSubview: _Scro];
}
-(void)CreatePlayList{
    //设置文字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, 375, 100)];
    label.font = [UIFont fontWithName:@"Helvetica" size:20];
    label.text = @"每日歌单推荐";
    [_Scro addSubview:label];
    //获取网络数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.diy.gedanHot&from=qianqianmini&version=11.0.5&platform=darwin&num=10" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"正在获取歌单数据");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据转字典
        NSDictionary *dic = (NSDictionary *)responseObject;
        dic = [dic objectForKey:@"content"];
        //创建一个数组接收模型
        NSArray *array = [PlayListModel mj_objectArrayWithKeyValuesArray:dic];
        //根据数组里面的模型更新UI
        for(PlayListModel *model in array){
            static int i = 2;
            CGFloat ImageViewWidth=180;CGFloat ImageViewHeight=180;CGFloat ImageViewX;CGFloat ImageViewY=100+(i/2)*(ImageViewHeight+80);
            if(i%2==0) ImageViewX=(i%2)*ImageViewWidth; else ImageViewX=(i%2)*ImageViewWidth+15;
            //创建一个imageview
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ImageViewX, ImageViewY, ImageViewWidth, ImageViewHeight)];
            //请求出图片
            imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.pic_300]]];
            //添加到view中
            [_Scro addSubview:imageView];
         //创建label
            CGFloat LabelX =(i%2)*ImageViewWidth;
            CGFloat LabelY = 100+(i/2)*(ImageViewHeight+80)+imageView.frame.size.height;
            CGFloat LabelWidth = 180;
            CGFloat LabelHeight = 80;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(LabelX, LabelY, LabelWidth, LabelHeight)];
            label.textAlignment = NSTextAlignmentCenter;
            //自动换行
            label.adjustsFontSizeToFitWidth = YES;
            label.numberOfLines = 0;
            label.text = model.title;
            [_Scro addSubview:label];
            i++;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误!%@",error);
    }];
}
-(void)CreateHeadScrollerView{
    __block UIScrollView *scro = [[UIScrollView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, 375, 250)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    scro.delegate = self;
    scro.backgroundColor = [UIColor whiteColor];
    //获取网络数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=ting.baidu.plaza.getFocusPic&from=qianqianmini&version=11.0.5&platform=darwin&num=6" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据转字典
        NSDictionary *dic = (NSDictionary *)responseObject;
        dic = [dic objectForKey:@"pic"];
        //数据模型转数组模型
        _array = [HeadImageModel mj_objectArrayWithKeyValuesArray:dic];
        //根据数组里面的模型更新UI
        for (HeadImageModel *model in _array) {
            static NSInteger i=0;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*scro.frame.size.width, 0, scro.frame.size.width, scro.frame.size.height)];
            //请求出图片
            imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.randpic]]];
            //将其添加到scrollView
            [scro addSubview:imageView];
            //给图片添加手势
            MyTapGestureRecognizer *tap = [[MyTapGestureRecognizer alloc]init];
            tap.tag = i;
            imageView.userInteractionEnabled = YES;
            NSRange range ={0,4};
            NSString *str = [model.code substringWithRange:range];
            if([str  isEqual: @"http"]){
                [tap addTarget:self action:@selector(Jump:)];
                [imageView addGestureRecognizer:tap];
            }
            i++;
        }
        [_Scro addSubview:scro];
        // 设置 scrollView的contentSize
        scro.contentSize = CGSizeMake(6 * scro.frame.size.width, 0);
        
        // 隐藏滚动指示器
        scro.showsHorizontalScrollIndicator = NO;
        
        // scrollView的分页效果 (根据scrollView的宽度进行分页的)
        scro.pagingEnabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];

}
-(void)Jump:(id)sender{
    MyTapGestureRecognizer *tap = (MyTapGestureRecognizer *)sender;
    NSInteger i = tap.tag;
    //创建网页
    HeadImageModel *model =_array[i];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.code]]];
    self.navigationItem.title = @"网页";
    //添加返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(RemoveWeb)];
    webView.tag = 100;
    [self.view addSubview:webView];
    self.tabBarController.tabBar.hidden = YES;

}
-(void)RemoveWeb{
    UIView *view = [self.view viewWithTag:100];
    [view removeFromSuperview];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.title = @"首页";
    self.tabBarController.tabBar.hidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
