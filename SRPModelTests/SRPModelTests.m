//
//  SRPModelTests.m
//  SRPModelTests
//
//  Created by shinren.pan@gmail.com on 2016/5/19.
//  Copyright © 2016年 shinrenpan. All rights reserved.
//

#import "Model.h"
#import "MappingModel.h"
#import "PropertyModel.h"
#import "PropertyModels.h"
#import <XCTest/XCTest.h>

@interface SRPModelTests : XCTestCase

@end


@implementation SRPModelTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testModelFromDictionary
{
    NSDictionary *dic = @{@"property" : @"Hello world"};
    Model *model      = [Model modelFromDictionary:dic];
    
    XCTAssertTrue([model.property isEqualToString:dic[@"property"]]);
}

- (void)testModelsFromArray
{
    NSArray *array  = @[@{@"property" : @"Hello world"}];
    NSArray *models = [Model modelsFromArray:array];
    
    XCTAssertTrue([models.firstObject isKindOfClass:[Model class]]);
}

- (void)testModelPropertyMapping
{
    NSDictionary *dic   = @{@"_property" : @"Hello world"};
    MappingModel *model = [MappingModel modelFromDictionary:dic];
    
    XCTAssertTrue([model.property isEqualToString:dic[@"_property"]]);
}

- (void)testModelPropertyFromOtherModel
{
    NSDictionary *dic = @{@"model" : @{@"property" : @"Hello world"}};
    PropertyModel *model = [PropertyModel modelFromDictionary:dic];
    
    XCTAssertTrue([model.model isKindOfClass:[Model class]]);
}

- (void)testModelPropertyAsModels
{
    NSDictionary *dic = @{@"models" : @[@{@"property" : @"Hello world"}]};
    PropertyModels *model = [PropertyModels modelFromDictionary:dic];
    
    XCTAssertTrue([model.models.firstObject isKindOfClass:[Model class]]);
}

@end
