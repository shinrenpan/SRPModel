// SRPModelTest.m
// Copyright (c) 2016年 shinren.pan@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <XCTest/XCTest.h>
#import <SRPModel/SRPModel.h>

#pragma mark - Test model
@interface Model : SRPModel

@property (nonatomic, readonly) NSString *testString;
@property (nonatomic, readonly, assign) BOOL testBOOL;
@property (nonatomic, readonly, assign) NSInteger testInteger;
@property (nonatomic, readonly, assign) NSString *testDefaultValue;

@end


@implementation Model

+ (NSDictionary *)propertyMapping
{
    return @{@"string" : @"testString"};
}

+ (NSDictionary *)defaultValues
{
    return @{@"testDefaultValue" : @"defaultString"};
}

@end


#pragma mark - Test inherit model
@interface Son : Model

@property (nonatomic, readonly) CGFloat testFloat;

@end


@implementation Son

+ (BOOL)includeSuperClassProperties
{
    return YES;
}

@end



#pragma mark - Test case
@interface SRPModelTest : XCTestCase

@property (nonatomic, strong) Model *model;

@end


@implementation SRPModelTest

#pragma mark - LifeCycle
- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{
    _model = nil;
    [super tearDown];
}

#pragma mark - Test
- (void)testModelFromDictionary
{
    NSDictionary *dic = @{@"string" : @"string", @"testBOOL" : @YES, @"testInteger" : @100};
    Model *model      = [Model modelFromDictionary:dic];
    
    BOOL passString   = [model.testString isEqualToString:@"string"];
    BOOL passBOOL     = model.testBOOL;
    BOOL passInteger  = (model.testInteger == 100);
    
    XCTAssertTrue(passString && passBOOL && passInteger);
}

- (void)testModelFromJSONString
{
    NSString *JSON   = @"{\"string\" : \"string\", \"testBOOL\" : true, \"testInteger\" : 100}";
    Model *model     = [Model modelFromJSONString:JSON];
    
    BOOL passString  = [model.testString isEqualToString:@"string"];
    BOOL passBOOL    = model.testBOOL;
    BOOL passInteger = (model.testInteger == 100);
    
    XCTAssertTrue(passString && passBOOL && passInteger);
}

-(void)testModelsFromArray
{
    NSArray *array  = @[@{@"string" : @"string", @"testBOOL" : @YES, @"testInteger" : @100}];
    NSArray *models = [Model modelsFromArray:array];
    id firstModel   = models.firstObject;
    
    BOOL passModel   = [firstModel isKindOfClass:[Model class]];
    BOOL passString  = NO;
    BOOL passBOOL    = NO;
    BOOL passInteger = NO;
    
    if(passModel)
    {
        Model *model = firstModel;
        passString  = [model.testString isEqualToString:@"string"];
        passBOOL    = model.testBOOL;
        passInteger = (model.testInteger == 100);
    }
    
    XCTAssertTrue(passModel && passString && passBOOL && passInteger);
}

- (void)testModelsFromJSONString
{
    NSString *JSON  = @"[{\"string\" : \"string\", \"testBOOL\" : true, \"testInteger\" : 100}]";
    NSArray *models = [Model modelsFromJSONString:JSON];
    id firstModel   = models.firstObject;
    
    BOOL passModel   = [firstModel isKindOfClass:[Model class]];
    BOOL passString  = NO;
    BOOL passBOOL    = NO;
    BOOL passInteger = NO;
    
    if(passModel)
    {
        Model *model = firstModel;
        passString  = [model.testString isEqualToString:@"string"];
        passBOOL    = model.testBOOL;
        passInteger = (model.testInteger == 100);
    }
    
    XCTAssertTrue(passModel && passString && passBOOL && passInteger);
}

- (void)testInheritModel
{
    NSDictionary *dic = @{@"string" : @"string", @"testBOOL" : @YES, @"testInteger" : @100, @"testFloat" : @1.3};
    Son *son = [Son modelFromDictionary:dic];
    
    BOOL passString   = [son.testString isEqualToString:@"string"];
    BOOL passBOOL     = son.testBOOL;
    BOOL passInteger  = (son.testInteger == 100);
    BOOL passFloat    = (son.testFloat == 1.3);
    
    XCTAssertTrue(passString && passBOOL && passInteger && passFloat);
}

@end
