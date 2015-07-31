//
//  User.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "User.h"

@implementation User

-(void)setUserWithDataDic:(NSMutableDictionary *)dataDic{
    
    if([dataDic objectForKey:@"id"] && ![[dataDic objectForKey:@"id"] isEqual:@""] && ![[dataDic objectForKey:@"id"] isKindOfClass:[NSNull class]]){
        _userID = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"id"] intValue]];
    }
    
    if([dataDic objectForKey:@"name"] && ![[dataDic objectForKey:@"name"] isEqual:@""] && ![[dataDic objectForKey:@"name"] isKindOfClass:[NSNull class]]){
        _userName = [dataDic objectForKey:@"name"];
    }
    
    if([dataDic objectForKey:@"password"] && ![[dataDic objectForKey:@"password"] isEqual:@""] && ![[dataDic objectForKey:@"password"] isKindOfClass:[NSNull class]]){
        _userPwd = [dataDic objectForKey:@"password"];
    }
    
    if([dataDic objectForKey:@"phoneNum"] && ![[dataDic objectForKey:@"phoneNum"] isEqual:@""] && ![[dataDic objectForKey:@"phoneNum"] isKindOfClass:[NSNull class]]){
        _userPhoneNum = [dataDic objectForKey:@"phoneNum"];
    }
    
    if([dataDic objectForKey:@"homeId"] && ![[dataDic objectForKey:@"homeId"] isEqual:@""] && ![[dataDic objectForKey:@"homeId"] isKindOfClass:[NSNull class]]){
        _userHomeID = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"homeId"] intValue]];
    }
    
    if([dataDic objectForKey:@"rememberPwd"] && ![[dataDic objectForKey:@"rememberPwd"] isEqual:@""] && ![[dataDic objectForKey:@"rememberPwd"] isKindOfClass:[NSNull class]]){
        
        if([[dataDic objectForKey:@"rememberPwd"] isEqual:@"1"]){
            _isUserRememberPwd = YES;
        }else{
            _isUserRememberPwd = NO;
        }
        
    }
    
}

@end
