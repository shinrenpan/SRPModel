//
//  TestModelFromDictionary.m
//  SRPModel
//
//  Created by dev1 on 2016/9/9.
//  Copyright © 2016年 shinrenpan. All rights reserved.
//

#import "Model.h"
#import <XCTest/XCTest.h>
#import <SRPModel/SRPModel.h>

@interface TestModelFromDictionary : XCTestCase
@end

@implementation TestModelFromDictionary

- (void)testModelFromDictionary
{
    NSDictionary *dic = @{@"key" : @"pass"};
    Model *model      = [Model modelFromDictionary:dic];
    BOOL pass         = [model.key isEqualToString:dic[@"key"]];
    
    XCTAssertTrue(pass);
}

@end
