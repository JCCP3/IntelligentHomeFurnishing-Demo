//
//  BaseTabBarViewController.m
//  WisdomPension
//
//  Created by JC_CP3 on 15/5/5.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "IntelligentIntegratedDevicesViewController.h"
#import "IntelligentTaskViewController.h"
#import "IntelligentAlarmViewController.h"
#import "IntelligentUserSettingViewController.h"
#import "Utility.h"


@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(!_tabBarView){
        _tabBarView = [[[NSBundle mainBundle] loadNibNamed:@"tabBarView" owner:self options:nil] lastObject];
    }
    
    [_tabBarView setFrame:CGRectMake(0, DEVICE_AVALIABLE_HEIGHT-52.f, DEVICE_AVALIABLE_WIDTH, 52.f)];
    
    [self.view addSubview:_tabBarView];
    
    //适配
    [self layOutTabBarView];
    
}


-(void)layOutTabBarView{
    
    [_sepaLabel setFrame:CGRectMake(0, 0, DEVICE_AVALIABLE_WIDTH, 1)];
    [_sepaLabel setBackgroundColor:[Utility colorWithHexString:@"#cacaca"]];
    
    for (int i=100; i<104; i+=3) {
        
        UIButton *btn = (UIButton *)[_tabBarView viewWithTag:i];
        [btn setFrame:CGRectMake((i/103)*(DEVICE_AVALIABLE_WIDTH/2), 0, DEVICE_AVALIABLE_WIDTH/2, 52.f)];
        
        UILabel *lab = (UILabel *)[_tabBarView viewWithTag:i+100];
        [lab setFrame:CGRectMake(btn.frame.origin.x, lab.frame.origin.y, btn.bounds.size.width, lab.bounds.size.height)];
        
        UIImageView *imageView = (UIImageView *)[_tabBarView viewWithTag:i+200];
        [imageView setFrame:CGRectMake(btn.frame.origin.x+(btn.bounds.size.width-imageView.bounds.size.width)/2, imageView.frame.origin.y, imageView.bounds.size.width, imageView.bounds.size.height)];

    }
    
    
//    for (int i=100; i<104; i++) {
//        
//        UIButton *btn = (UIButton *)[_tabBarView viewWithTag:i];
//        [btn setFrame:CGRectMake((i-100)*(DEVICE_AVALIABLE_WIDTH/4), 0, DEVICE_AVALIABLE_WIDTH/4, 52.f)];
//        
//        UILabel *lab = (UILabel *)[_tabBarView viewWithTag:i+100];
//        [lab setFrame:CGRectMake(btn.frame.origin.x, lab.frame.origin.y, btn.bounds.size.width, lab.bounds.size.height)];
//        
//        UIImageView *imageView = (UIImageView *)[_tabBarView viewWithTag:i+200];
//        [imageView setFrame:CGRectMake(btn.frame.origin.x+(btn.bounds.size.width-imageView.bounds.size.width)/2, imageView.frame.origin.y, imageView.bounds.size.width, imageView.bounds.size.height)];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickChangeAppFunction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if(btn.tag == 100){
        //我的家庭
        IntelligentIntegratedDevicesViewController *integratedDevicesViewController =    [APPDELEGATE integratedDeviceViewController];
        
        if(!integratedDevicesViewController){
            integratedDevicesViewController = [[IntelligentIntegratedDevicesViewController alloc] init];
            [APPDELEGATE setIntegratedDeviceViewController:integratedDevicesViewController];
        }
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:integratedDevicesViewController];
        
        [APPDELEGATE window].rootViewController = navController;
        
    }else if (btn.tag == 101){
        
        //任务
        IntelligentTaskViewController *taskViewController =    [APPDELEGATE taskViewController];
        
        if(!taskViewController){
            taskViewController = [[IntelligentTaskViewController alloc] init];
            [APPDELEGATE setTaskViewController:taskViewController];
        }
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:taskViewController];
        
        [APPDELEGATE window].rootViewController = navController;
        
        
    }else if (btn.tag == 102){
        
        //报警
//        IntelligentAlarmViewController *alarmViewController =    [APPDELEGATE alarmViewController];
//        
//        if(!alarmViewController){
//            alarmViewController = [[IntelligentAlarmViewController alloc] init];
//            [APPDELEGATE setAlarmViewController:alarmViewController];
//        }
        
        ContexualModelViewController *viewController= [APPDELEGATE contextualModelViewController];
        
        if(!viewController){
            viewController = [[ContexualModelViewController alloc] init];
            
            [APPDELEGATE setContextualModelViewController:viewController];
        }
    
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [APPDELEGATE window].rootViewController = navController;
        
        
    }else{
        
        //设置 
        IntelligentUserSettingViewController *userSettingViewController = [APPDELEGATE userSettingViewController];
        
        if(!userSettingViewController){
            userSettingViewController = [[IntelligentUserSettingViewController alloc] init];
            [APPDELEGATE setUserSettingViewController:userSettingViewController];
        }
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:userSettingViewController];
        
        [APPDELEGATE window].rootViewController = navController;
        
    }
    
}
@end
