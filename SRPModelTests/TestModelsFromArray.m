//
//  TestModelsFromArray.m
//  SRPModel
//
//  Created by dev1 on 2016/9/9.
//  Copyright © 2016年 shinrenpan. All rights reserved.
//

#import "Model.h"
#import <XCTest/XCTest.h>
#import <SRPModel/SRPModel.h>

@interface TestModelsFromArray : XCTestCase
@end

@implementation TestModelsFromArray

-(void)testModelsFromArray
{
    NSArray *array  = @[@{@"key" : @"pass"}];
    NSArray *models = [Model modelsFromArray:array];
    id firstModel   = models.firstObject;
    BOOL pass       = [firstModel isKindOfClass:[Model class]];
    
    XCTAssertTrue(pass);
}

@end
