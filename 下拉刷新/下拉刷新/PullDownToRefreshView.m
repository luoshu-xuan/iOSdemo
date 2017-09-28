//
//  PullDownToRefreshView.m
//  下拉刷新
//
//  Created by 尹键溶 on 2017/7/8.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "PullDownToRefreshView.h"

//枚举可能存在的所有状态
typedef enum{
    MyPullDownToRefreshViewStatusNormal,  //正常状态
    MyPullDownToRefreshViewStatusPulling, // 释放刷新状态
    MyPullDownToRefreshViewStatusRefreshing //正在刷新
}MyPullDownToRefreshViewStatus;

@interface PullDownToRefreshView()

@property(strong,nonatomic)UIImageView *RefreshPhoto;

@property(strong,nonatomic)UILabel *label;
//播放动画的图片的数组
@property(nonatomic,strong)NSArray *RefreshAnimationImage;
//纪录当前状态
@property(nonatomic,assign)MyPullDownToRefreshViewStatus NowStatus;
//父控件属性 因为tableview和controllowview都属于UIScorllview 所以设置这个类型
@property(nonatomic,strong)UIScrollView *superview;
@end

@implementation PullDownToRefreshView

//观察可以发现 监听的对象是父控件 故可以使用下面这个方法
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    //因为父控件要使用多次 故加上这个属性
    //只有能滚动的父控件才需要被监听
    if([newSuperview isKindOfClass:[UIScrollView class]]){
        self.superview = (UIScrollView *)newSuperview;
        //开始调用监听方法
        // 监听父控件的滚动其实就是监听 self.superScrollView 对象的 cotentOffset 属性的改变
        // KVO: Key-Value observing
        // KVO: 键值监听
        // KVO作用: 就是来监听一个对象的属性的改变
        // KVO使用: 要监听哪个对象就用哪个对象调用 addObserver:forKeyPath:options:context 方法
        // 参数:
        // addObserver: 谁来监听
        // forKeyPath: 要监听的属性
        // KVO: 当监听对象的身上的属性发生改变会调用addObserver 对象的 observeValueForKeyPath:ofObject:change:context
        // 注意: 使用KVO和使用通知一样需要 取消
        [self.superview addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    }
}
//监听时的方法使用这个
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //根据拖动的长度来切换状态
    if(self.superview.isDragging){
        CGFloat normalPullingOfset = -124;
        if(self.superview.contentOffset.y>normalPullingOfset && self.NowStatus == MyPullDownToRefreshViewStatusPulling){
            self.NowStatus = MyPullDownToRefreshViewStatusNormal;
        }
        else if(self.superview.contentOffset.y<normalPullingOfset && self.NowStatus == MyPullDownToRefreshViewStatusNormal){
            self.NowStatus = MyPullDownToRefreshViewStatusPulling;

        }
    }
    else{
        if(self.NowStatus == MyPullDownToRefreshViewStatusPulling){
            self.NowStatus = MyPullDownToRefreshViewStatusRefreshing;
        }
    }
}

- (void)dealloc{
    //移除KVO监听
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}
//为了改变view里的文字 于是在状态的set方法中进行修改
-(void)setNowStatus:(MyPullDownToRefreshViewStatus)NowStatus{
    _NowStatus = NowStatus;
    switch (_NowStatus) {
        case MyPullDownToRefreshViewStatusNormal:
            //结束动画
            [self.RefreshPhoto stopAnimating];
            self.RefreshPhoto.image = [UIImage imageNamed:@"normal"];
            self.label.text = @"下拉可刷新";
            NSLog(@"正常状态");
            break;
        case MyPullDownToRefreshViewStatusPulling:
            self.RefreshPhoto.image = [UIImage imageNamed:@"pulling"];
            self.label.text = @"松开可刷新";
            NSLog(@"切换至松开刷新状态");
            break;
        default: MyPullDownToRefreshViewStatusRefreshing:
            self.label.text = @"正在加载...";
            self.RefreshPhoto.animationImages = self.RefreshAnimationImage;
            self.RefreshPhoto.animationDuration = 0.1*self.RefreshAnimationImage.count;
            NSLog(@"切换至刷新状态");
            //开始动画
            [self.RefreshPhoto startAnimating];
            //让tableview往下面走 顺便做个动画
            [UIView animateWithDuration:0.25 animations:^{
                self.superview.contentInset = UIEdgeInsetsMake(self.superview.contentInset.top+60, self.superview.contentInset.left, self.superview.contentInset.bottom, self.superview.contentInset.right);
            }];
            if(_RefreshBlock){
                self.RefreshBlock();
            }
            break;
    }
}
-(void)endAnimation{
    //状态切换
    if(self.NowStatus == MyPullDownToRefreshViewStatusRefreshing){
        self.NowStatus = MyPullDownToRefreshViewStatusNormal;
        //让该view上去
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.contentInset = UIEdgeInsetsMake(self.superview.contentInset.top-60, self.superview.contentInset.left, self.superview.contentInset.bottom, self.superview.contentInset.right);
        }];

    }
}

//懒加载结束后 就添加这两个控件
//之所以使用initwithframe 是因为调用的时候无论使用的是init 还是initwithframe 都要调用这个方法
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
    [self addSubview:self.RefreshPhoto];
    [self addSubview:self.label];
    
    //设置这两个的frame
    self.RefreshPhoto.frame = CGRectMake(130, 5, 50, 50);
    self.label.frame = CGRectMake(190, 20, 200, 20);
}
        return self;
}

//对图片和label进行懒加载
- (UIImageView *)RefreshPhoto{
    if(_RefreshPhoto == nil){
        UIImage *nomoral = [UIImage imageNamed:@"normal"];
        _RefreshPhoto = [[UIImageView alloc]initWithImage:nomoral];
    }
    return _RefreshPhoto;
}
- (UILabel *)label{
    if(_label == nil){
//        不知道什么用
        _label = [[UILabel alloc]init];
        //设置一些属性
        _label.text = @"下拉刷新";
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor darkGrayColor];
    }
    return _label;
}
//对图片数组进行懒加载
- (NSArray*)RefreshAnimationImage{
    //判断是否为空
    if (_RefreshAnimationImage==nil) {
        //创建一个动态数组
        NSMutableArray *temp = [NSMutableArray array];
        //进行图片的加入
        for(int i=1;i<4;i++){
            NSString *imageName = [NSString stringWithFormat:@"refreshing_0%d",i];
            UIImage *nowImage = [UIImage imageNamed:imageName];
            [temp addObject:nowImage];
        }
        //这个时候temp数组里面已经存在了三张图片
        _RefreshAnimationImage = temp;
    }
    return _RefreshAnimationImage;
}

@end
