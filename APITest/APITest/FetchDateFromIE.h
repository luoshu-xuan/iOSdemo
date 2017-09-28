//
//  FetchDateFromIE.h
//  APITest
//
//  Created by 尹键溶 on 2017/9/26.
//  Copyright © 2017年 st`. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchDateFromIE : NSObject
//block用来获取回调的数据
typedef void(^MySuccessBlock)(NSData *data,NSURLResponse *response);
//这个类方法用来获取数据
+(void)fetchMusicData:(NSString *)SingName WithBack:(MySuccessBlock)callback;
@end
