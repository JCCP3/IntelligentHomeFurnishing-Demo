//
//  RequestService.m
//  FindNearest_3.0
//
//  Created by 会搜 on 15/3/7.
//  Copyright (c) 2015年 纪超Cp3. All rights reserved.
//

#import "RequestService.h"
#import "AFNetworking.h"
#import "NSString+SBJSON.h"
#define TimeOut 30

@implementation RequestService

+(RequestService *)defaultRequestService{
    
    static RequestService *defaultRequestService = nil;
    //添加该字段 防止多线程时数据请求
    @synchronized(self){
        if(!defaultRequestService){
            defaultRequestService = [[RequestService alloc] init];
        }
    }
    return defaultRequestService;
    
}

-(void)asyncGetDataWithURL:(NSString *)requestURL paramDic:(NSMutableDictionary *)paramDic responseDicBlock:(void (^)(NSMutableDictionary *))repsonseDic errorBlock:(void (^)(NSString *))errorMessage{
    
    @synchronized(self){
        
        NSString *currentRequestURL;
        
        currentRequestURL = [[NSString stringWithFormat:@"http://%@:%@/",[APPDELEGATE appServerURL],[APPDELEGATE appServerPort]] stringByAppendingString:requestURL];
        
        if(paramDic && [[paramDic allKeys] count]>0){
            
            currentRequestURL = [currentRequestURL stringByAppendingString:@"?"];
            
            //异步get
            for (int i = 0; i<[[paramDic allKeys] count]; i++) {
                
                NSString *currentKey = [[paramDic allKeys] objectAtIndex:i];
                NSString *currentValue = [paramDic objectForKey:currentKey];
                NSString *currentKeyAndValue = @"";
                if(i < [[paramDic allKeys] count] - 1){
                    currentKeyAndValue = [currentKey stringByAppendingString:[NSString stringWithFormat:@"=%@&",currentValue]];
                }else{
                    currentKeyAndValue = [currentKey stringByAppendingString:[NSString stringWithFormat:@"=%@",currentValue]];
                }
                
                currentRequestURL = [currentRequestURL stringByAppendingString:currentKeyAndValue];
                
            }
            
        }

        currentRequestURL = [currentRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",currentRequestURL); //当前需求的URL
      
        
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        
        //设置超时时间
        manager.requestSerializer.timeoutInterval = TimeOut;
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:currentRequestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            
            NSString *responseStr = operation.responseString;
            
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
            
            NSData*jsondata = operation.responseData;
            
            responseStr = [[NSString alloc]initWithBytes:[jsondata bytes]length:[jsondata length] encoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *recDic = [responseStr JSONValue];
            
            repsonseDic(recDic);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            errorMessage([NSString stringWithFormat:@"%@",[operation error]]);
            
        }];
        
    }
    
}



//异步Post请求
-(void)asyncPostDataWithURL:(NSString *)requestURL paramDic:(NSMutableDictionary *)paramDic responseDicBlock:(void (^)(NSMutableDictionary *))responseDic errorBlock:(void (^)(NSString *))errorMessage{
    
    @synchronized(self){
        
        NSString *currentRequestURL;
        
        currentRequestURL = [[NSString stringWithFormat:@"http://%@:%@/",[APPDELEGATE appServerURL],[APPDELEGATE appServerPort]] stringByAppendingString:requestURL];
        
        currentRequestURL = [currentRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",currentRequestURL); //当前需求的URL
        
       
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:currentRequestURL]];
        
        manager.requestSerializer.timeoutInterval = TimeOut;//sh
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:currentRequestURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
            
            NSString *responseStr = operation.responseString;
            
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
            
            NSData*jsondata = operation.responseData;
            
            responseStr = [[NSString alloc]initWithBytes:[jsondata bytes]length:[jsondata length] encoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *recDic = [responseStr JSONValue];
            
            responseDic(recDic);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            errorMessage([NSString stringWithFormat:@"%@",[operation error]]);
            
        }];
        
    }
    
    
}


- (void)saveCookies{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}

- (void)loadCookies{
    
    if([[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"] && ![[[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"] isEqual:@""]){
        
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        for (NSHTTPCookie *cookie in cookies){
            [cookieStorage setCookie: cookie];
        }
    }
}

@end
