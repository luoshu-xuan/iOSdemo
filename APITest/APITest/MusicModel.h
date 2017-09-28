//
//  MusicModel.h
//  APITest
//
//  Created by 尹键溶 on 2017/9/26.
//  Copyright © 2017年 st`. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property(nonatomic,strong) NSString *MusicName;
@property(nonatomic,strong) NSString *SingerName;
@property(nonatomic,strong) NSString *ImageURL;

//api
+(id)musicDataWithDic:(NSDictionary *)dic;
@end
