//
//  TestModelFromJSONString.m
//  SRPModel
//
//  Created by dev1 on 2016/9/9.
//  Copyright © 2016年 shinrenpan. All rights reserved.
//

#import "Model.h"
#import <XCTest/XCTest.h>
#import <SRPModel/SRPModel.h>

@interface TestModelFromJSONString : XCTestCase
@end

@implementation TestModelFromJSONString

- (void)testModelFromJSONString
{
    NSString *JSON = @"{\"key\" : \"pass\"}";
    Model *model   = [Model modelFromJSONString:JSON];
    BOOL pass      = [model.key isEqualToString:@"pass"];
    
    XCTAssertTrue(pass);
}

@end
