//
//  AudioModel.h
//  声音播放器
//
//  Created by 尹键溶 on 2017/7/18.
//  Copyright © 2017年 st`. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioModel : NSObject
@property(nonatomic,strong)NSString* audioName;
@property(nonatomic,strong)NSString* singerName;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end
