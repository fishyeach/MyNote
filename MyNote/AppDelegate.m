//
//  AppDelegate.m
//  MyNote
//
//  Created by xd_ on 15-4-2.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController3.h"
#import "CategoryTool.h"
#import "DataBaseTool.h"
#import "DataInfoTool.h"
#import "TemplateTool.h"
#import "BudgetTool.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

//    [[UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil].shadowImage = [[UIImage alloc] init];
    [[UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil] setBarTintColor:[UIColor yellowColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor yellowColor]];
    [[UITabBar appearance] setTintColor:myRedColor];
    
//    self.window.rootViewController = [[ViewController alloc] init];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        NSLog(@"首次打开");
        [CategoryTool opendDB];
        [CategoryTool creatCategoryTable];
        [CategoryTool firstAdd];
        [CategoryTool closeDB];
        
        [DataInfoTool opendDB];
        [DataInfoTool creatTable];
        [DataInfoTool closeDB];
        
        [TemplateTool opendDB];
        [TemplateTool creatTable];
        [TemplateTool closeDB];
        
        [BudgetTool opendDB];
        [BudgetTool creatTable];
        [BudgetTool closeDB];
        
    }
    
    NSLog(@"didFinishLaunchingWithOptions");
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

     NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     NSLog(@"applicationDidBecomeActive");
//    [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor orangeColor];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      NSLog(@"applicationWillTerminate");
}

@end
