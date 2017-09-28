//
//  AudioModel.m
//  声音播放器
//
//  Created by 尹键溶 on 2017/7/18.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "AudioModel.h"

@implementation AudioModel

-(instancetype)initWithDict:(NSDictionary*)dict{
    if(self=[super init]){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
