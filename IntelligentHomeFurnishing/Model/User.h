//
//  User.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/18.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic ,strong)NSString *userID;
@property (nonatomic ,strong)NSString *userName;
@property (nonatomic ,strong)NSString *userPwd;
@property (nonatomic ,strong)NSString *userPhoneNum;
@property (nonatomic ,strong)NSString *userHomeID;
@property (nonatomic ,assign)BOOL isUserRememberPwd;

-(void)setUserWithDataDic:(NSMutableDictionary *)dataDic;

@end
