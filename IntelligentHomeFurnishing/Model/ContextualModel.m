//
//  ContextualModel.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/25.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "ContextualModel.h"

@implementation ContextualModel

-(void)setContextualModelWithDataDic:(NSMutableDictionary *)dataDic{
    
    if([dataDic objectForKey:@"id"] && ![[dataDic objectForKey:@"id"] isEqual:@""] && ![[dataDic objectForKey:@"id"] isKindOfClass:[NSNull class]]){
        _contextualModelID = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"id"] intValue]];
    }
    
    if([dataDic objectForKey:@"name"] && ![[dataDic objectForKey:@"name"] isEqual:@""] && ![[dataDic objectForKey:@"name"] isKindOfClass:[NSNull class]]){
        _contextualModelName = [dataDic objectForKey:@"name"];
    }
    
    if([dataDic objectForKey:@"description"] && ![[dataDic objectForKey:@"description"] isEqual:@""] && ![[dataDic objectForKey:@"description"] isKindOfClass:[NSNull class]]){
        _contextualModelDesc = [dataDic objectForKey:@"description"];
    }
    
    if([dataDic objectForKey:@"homeId"] && ![[dataDic objectForKey:@"homeId"] isEqual:@""] && ![[dataDic objectForKey:@"homeId"] isKindOfClass:[NSNull class]]){
        _contextualModelHomeID = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"homeId"] intValue]];
    }
    
    if([dataDic objectForKey:@"openCommand"] && ![[dataDic objectForKey:@"openCommand"] isEqual:@""] && ![[dataDic objectForKey:@"openCommand"] isKindOfClass:[NSNull class]]){
        _contextualOpenCommand = [dataDic objectForKey:@"openCommand"];
    }
    
    
    if([dataDic objectForKey:@"closeCommand"] && ![[dataDic objectForKey:@"closeCommand"] isEqual:@""] && ![[dataDic objectForKey:@"closeCommand"] isKindOfClass:[NSNull class]]){
        _contextualCloseCommand = [dataDic objectForKey:@"closeCommand"];
    }
    
    if([dataDic objectForKey:@"type"] && ![[dataDic objectForKey:@"type"] isEqual:@""] && ![[dataDic objectForKey:@"type"] isKindOfClass:[NSNull class]]){
        _contextualModelType = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"type"] intValue]];
    }
    
}

@end
