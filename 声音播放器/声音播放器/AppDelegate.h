//
//  AppDelegate.h
//  声音播放器
//
//  Created by 尹键溶 on 2017/7/17.
//  Copyright © 2017年 st`. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

