//
//  PropertyModels.m
//  SRPModel
//
//  Created by shinren.pan@gmail.com on 2016/5/19.
//  Copyright © 2016年 shinrenpan. All rights reserved.
//

#import "PropertyModels.h"

@implementation PropertyModels

+ (NSArray *)newModelsFromArray:(NSArray *)array forProperty:(NSString *)property
{
    if([property isEqualToString:@"models"])
    {
        return [Model modelsFromArray:array];
    }
    
    return nil;
}

@end
