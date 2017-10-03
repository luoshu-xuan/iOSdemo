//
//  AppDelegate.m
//  Home
//
//  Created by 尹键溶 on 2017/10/1.
//  Copyright © 2017年 st`. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "FindViewController.h"
#import "MeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //创建主页controller
    HomeViewController *home = [[HomeViewController alloc]init];
    home.title = @"首页";
    home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"sun_set_126px_1174751_easyicon.net"] selectedImage:[UIImage imageNamed:@"sun_set_126px_1174751_easyicon.net"]];

    //创建tabarcontroller
    UITabBarController *tab = [[UITabBarController alloc]init];
    self.window.rootViewController = tab;
    //初始化navigation 使home成为根视图后把navigation加入到tabbar中
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
    [tab addChildViewController:nav];
    
    //创建搜索Controller
    FindViewController *find = [[FindViewController alloc]init];
    find.title = @"搜索";
    find.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"搜索" image:[UIImage imageNamed:@"search_engine_783px_1207845_easyicon.net"] selectedImage:[UIImage imageNamed:@"search_engine_783px_1207845_easyicon.net"]];
    UINavigationController *navFind = [[UINavigationController alloc]initWithRootViewController:find];
    [tab addChildViewController:navFind];

    
    //创建Me的controller
    MeViewController *me = [[MeViewController alloc]init];
    me.title = @"我的音乐";
    me.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的音乐" image:[UIImage imageNamed:@"head_set_199px_1189541_easyicon.net"] selectedImage:[UIImage imageNamed:@"head_set_199px_1189541_easyicon.net"]];
    UINavigationController *navMe = [[UINavigationController alloc]initWithRootViewController:me];
    [tab addChildViewController:navMe];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Home"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
