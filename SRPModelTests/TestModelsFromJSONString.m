//
//  TestModelsFromJSONString.m
//  SRPModel
//
//  Created by dev1 on 2016/9/9.
//  Copyright © 2016年 shinrenpan. All rights reserved.
//

#import "Model.h"
#import <XCTest/XCTest.h>
#import <SRPModel/SRPModel.h>

@interface TestModelsFromJSONString : XCTestCase
@end

@implementation TestModelsFromJSONString

- (void)testModelsFromJSONString
{
    NSString *JSON = @"[{\"key\" : \"pass\"}]";
    NSArray *models = [Model modelsFromJSONString:JSON];
    id firstModel   = models.firstObject;
    BOOL pass       = [firstModel isKindOfClass:[Model class]];
    
    XCTAssertTrue(pass);
}

@end
