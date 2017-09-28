//
//  PullDownToRefreshView.h
//  下拉刷新
//
//  Created by 尹键溶 on 2017/7/8.
//  Copyright © 2017年 st`. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownToRefreshView : UIView
@property(nonatomic,copy) void(^RefreshBlock)();

-(void)endAnimation;
@end
