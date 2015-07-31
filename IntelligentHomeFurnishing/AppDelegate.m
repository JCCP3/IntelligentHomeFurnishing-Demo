//
//  AppDelegate.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/15.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "AppDelegate.h"
#import "UserLoginViewController.h"
#define CURRENT_LOGIN_USER @"CURRENT_LOGIN_USER"
#import "ContexualModelViewController.h"
#import "APService.h"
#import "Utility.h"
#import "NSString+SBJSON.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /* 注册推送 */
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];

 
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //设置请求数据默认值
    if([APPDELEGATE checkCurrentAppServer]){
        //设置进去
        
    }else{
        
        //当前没有配置
        [self setAppServerPort:@"8089"];
//        [self setAppServerURL:@"114.215.191.63"];
        [self setAppServerURL:@"115.236.70.155"];
        
    }
    
    
    
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if([self checkUserIsLogin]){
        
        //用户已经登陆
        
//        ContexualModelViewController *viewController = [[ContexualModelViewController alloc] init];
        
        _integratedDeviceViewController = [[IntelligentIntegratedDevicesViewController alloc] init];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_integratedDeviceViewController];
        
        _window.rootViewController = navController;
        
        [_window makeKeyAndVisible];
        
    }else{
        
        
        UserLoginViewController *viewController = [[UserLoginViewController alloc] init];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        _window.rootViewController = navController;
        
        [_window makeKeyAndVisible];
        
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


/* 推送服务相关操作代码 */
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //得到当前设备的token
    [APService registerDeviceToken:deviceToken];
    
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
  
    [APService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    /*
     
     new
     close
     finish
     remark
     change
     
     */
   
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [APService handleRemoteNotification:userInfo];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    //处理相应事件
    if([userInfo objectForKey:@"sss"] && ![[userInfo objectForKey:@"sss"] isEqual:@""]){
        
        if([Utility isCurrentViewControllerVisible:_integratedDeviceViewController]){
            NSString *currentString = [[userInfo objectForKey:@"sss"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:currentString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            ////[alertView show];
            [_integratedDeviceViewController reloadCurrentTableView:[currentString JSONValue]];
        }
    }
    
    if([userInfo objectForKey:@"mss"] && ![[userInfo objectForKey:@"mss"] isEqual:@""]){
        
        //更改开关状态
        if([Utility isCurrentViewControllerVisible:_integratedDeviceViewController]){
            NSString *currentString = [[userInfo objectForKey:@"mss"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:currentString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //[alertView show];
            [_integratedDeviceViewController reloadMultiTableView:[currentString JSONValue]];
        }

    }
    
    if([userInfo objectForKey:@"heartbeatInfo"] && ![[userInfo objectForKey:@"heartbeatInfo"] isEqual:@""]){
        
        //更改开关状态
        if([Utility isCurrentViewControllerVisible:_integratedDeviceViewController]){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[userInfo objectForKey:@"heartbeatInfo"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //[alertView show];
            [_integratedDeviceViewController reloadHeaderView];
            
        }
        
    }
    
    if([userInfo objectForKey:@"cclogin"] && ![[userInfo objectForKey:@"cclogin"] isEqual:@""]){
        
        //更改开关状态
        if([Utility isCurrentViewControllerVisible:_integratedDeviceViewController]){
            NSString *currentString = [[userInfo objectForKey:@"cclogin"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:currentString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //[alertView show];
            [_integratedDeviceViewController reloadCenterControllerStatus:[currentString JSONValue]];
        }
        
    }
    
    if([userInfo objectForKey:@"warning"] && ![[userInfo objectForKey:@"warning"] isEqual:@""]){
        
        //进入我的家庭开关
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:[userInfo objectForKey:@"warning"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        //[alertView show];
        
        _integratedDeviceViewController = [[IntelligentIntegratedDevicesViewController alloc] init];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_integratedDeviceViewController];
        
        [APPDELEGATE window].rootViewController = navController;

    }
    
   
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}



#pragma mark 用户账户相关操作
//判断用户是否已经登录 (并且验证是否修改过密码)
-(BOOL)checkUserIsLogin{
    
    //判断当前用户是否存在
    if(_user){
        return YES;
    }else{
        //当前用户不存在
        if([[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_LOGIN_USER]){
            //当前用户登录过
            User *user = [[User alloc] init];
            [user setUserWithDataDic:[[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_LOGIN_USER]];
            [self set_user:user]; //设置APPDELEGATE中的user
            return YES;
        }else{
            //当前用户没有登录过
            return NO;
        }
    }
}


-(void)setCurrentLoginUser:(NSMutableDictionary *)dic{
    
    if(dic && ![dic isKindOfClass:[NSNull class]]){
        
        if(!_user){
            //当前用户不存在
            User *currentUser = [[User alloc] init];
            [currentUser setUserWithDataDic:dic];
            [self set_user:currentUser];
        }
        
        if(_user){
            [_user setUserWithDataDic:dic];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:CURRENT_LOGIN_USER];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
}


-(void)destoryUser{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_LOGIN_USER];
    [APPDELEGATE set_user:nil];
}

//设置user
-(void)set_user:(User *)user{
    _user = user;
}

-(void)set_AppServerURL:(NSString *)appServerURL{
    _appServerURL = appServerURL;
}

-(void)set_AppServerPort:(NSString *)appServerPort{
    _appServerPort = appServerPort;
}

//服务器配置
-(void)setCurrentAppServer:(NSString *)appURL withPort:(NSString *)port{
    
    [self set_AppServerURL:appURL];
    [self set_AppServerPort:port];
    
    [[NSUserDefaults standardUserDefaults] setObject:appURL forKey:APPSERVERURL];
    [[NSUserDefaults standardUserDefaults] setObject:port forKey:APPSERVERPORT];
}

//检测当前有没有输入过服务器
-(BOOL)checkCurrentAppServer{
    
    if(_appServerURL && _appServerPort){
        return YES;
    }else{
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:APPSERVERURL] && [[NSUserDefaults standardUserDefaults] objectForKey:APPSERVERPORT]){
            
            [self set_AppServerURL:[[NSUserDefaults standardUserDefaults] objectForKey:APPSERVERURL]];
            
            [self set_AppServerPort:[[NSUserDefaults standardUserDefaults] objectForKey:APPSERVERPORT]];
            
            return YES;
        }else{
            
            
            return NO;
        }
        
    }
    
}

/* 检验通知开关  */
-(BOOL)checkNotificationSwitchIsOpen{
    
    if(_notificationSwitchState && ![_notificationSwitchState isEqual:@""]){
        return YES;
    }else{
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATIONISOPEN]){
            _notificationSwitchState = [[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATIONISOPEN];
            return YES;
        }else{
            return NO;
        }
    }
    
}

-(void)setNotificationSwitch:(NSString *)switchState{
    
    if(!_notificationSwitchState || [_notificationSwitchState isEqual:@""]){
        
        _notificationSwitchState = switchState;
        
    }
    
    if(_notificationSwitchState && ![_notificationSwitchState isEqual:@""]){
        
        [[NSUserDefaults standardUserDefaults] setObject:_notificationSwitchState forKey:switchState];
        
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

/* 解析dic */
- (NSDictionary *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
//    NSString *tempStr1 =
//    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
//                                                 withString:@"\\U"];
//    NSString *tempStr2 =
//    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString *tempStr3 =
//    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *str =
//    [NSPropertyListSerialization propertyListFromData:tempData
//                                     mutabilityOption:NSPropertyListImmutable
//                                               format:NULL
//                                     errorDescription:NULL];
  
//        NSString *character = nil;
//        for (int i = 0; i < dic.description.length; i ++) {
//            character = [dic.description substringWithRange:NSMakeRange(i, 1)];
//            if ([character isEqualToString:@"\\"]){
//                [dic.description deleteCharactersInRange:NSMakeRange(i, 1)];
//            }
//            
//        }
//    
//    return [str JSONValue];
    
    return nil;
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
