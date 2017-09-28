//
//  FetchDateFromIE.m
//  APITest
//
//  Created by 尹键溶 on 2017/9/26.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "FetchDateFromIE.h"

@implementation FetchDateFromIE

+(void)fetchMusicData:(NSString *)SingName WithBack :(MySuccessBlock)callback{
    //qq音乐API
        NSString *URLString = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.search.merge&from=qianqianmini&version=11.0.5&platform=darwin&isNew=1&query=%@&page_no=1&page_size=20",SingName];
//    NSURL *TestURL = [NSURL URLWithString:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.search.merge&from=qianqianmini&version=11.0.5&platform=darwin&isNew=1&query=%E6%B6%88%E6%84%81&page_no=1&page_size=20"];
    NSURL *TestURL = [NSURL URLWithString:URLString];
    
    //    //创建一个url
    //    NSURL *musicURL = [NSURL URLWithString:URLString];
    //
    //创建该路径下的网络请求 用来设置http头部中的参数和方法类型
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:TestURL];
    //请求方法默认为get
    //    request.HTTPMethod = @"POST";
    //修改http请求头
    [request setValue:@"application/x-javascript;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"deflate,gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    
    
    //建立连接
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"失败！,%@",error);
        }else{
            NSLog(@"FE进行请求");
            callback(data,response);
        }
        
    }]resume];
    
}
@end
