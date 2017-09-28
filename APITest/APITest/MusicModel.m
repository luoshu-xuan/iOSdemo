//
//  MusicModel.m
//  APITest
//
//  Created by 尹键溶 on 2017/9/26.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
+(id)musicDataWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

-(id)initWithDic:(NSDictionary *)dic{
    if(self=[super init]){
        self.SingerName = dic[@"author"];
        self.MusicName = dic[@"title"];
        self.ImageURL = dic[@"pic_small"];
    }
    return self;
}
@end
