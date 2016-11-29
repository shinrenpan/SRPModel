//
// Copyright (c) 2016 shinren.pan@gmail.com
//

#import <XCTest/XCTest.h>
#import <SRPModel/SRPModel.h>


#pragma mark - SuperModel
@interface SuperModel: SRPModel
@property (nonatomic, readonly) NSInteger integerValue;
@property (nonatomic, readonly) NSString *stringValue;
@end

@implementation SuperModel
@end


#pragma mark - BaseModel
@interface Model : SuperModel
@property (nonatomic, readonly) CGFloat cgfloatValue;
@property (nonatomic, readonly) BOOL boolValue;
@property (nonatomic, readonly) NSString *defaultValue;
@property (nonatomic, readonly) NSDate *dateValue;

@end


@implementation Model

+ (NSDictionary<NSString *,NSString *> *)keyMapping
{
    return @{@"BOOL" : @"boolValue"};
}

+ (NSDictionary *)defaultKeysValues
{
    return @{@"defaultValue" : @"HellWorld"};
}

+ (id)dateValueTransformValue:(id)oldValue
{
    if([oldValue isKindOfClass:[NSNumber class]])
    {
        return [NSDate dateWithTimeIntervalSince1970:[oldValue doubleValue]];
    }
    
    return nil;
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
    NSDictionary *dic = @{@"cgfloatValue" : @10.1,
                          @"BOOL" : @YES,
                          @"integerValue" : @10,
                          @"stringValue" : @"HelloSuperClass",
                          @"dateValue" : @([NSDate date].timeIntervalSince1970)
                          };
    
    _model = [Model modelFromDictionary:dic];
}

- (void)tearDown
{
    _model = nil;
}

#pragma mark - Test
#pragma mark Test property cgfloatValue
- (void)testCGFloatValue
{
    XCTAssertEqualWithAccuracy(_model.cgfloatValue, 10.1, 0.01, @"");
}

#pragma mark Test property boolValue
- (void)testBOOLValue
{
    XCTAssertEqual(_model.boolValue, YES, @"Model booValue should be YES");
}

#pragma mark Test property defaultValue
- (void)testDefaultValue
{
    XCTAssertEqual(_model.defaultValue, @"HellWorld", @"Model defaultValue should be HellWorld");
}

#pragma mark Test property integerValue
- (void)testSuperClassIntegerValue
{
    XCTAssertEqual(_model.integerValue, 10, @"Model integerValue should be 10");
}

#pragma mark Test property stringValue
- (void)testSuperClassStringValue
{
    XCTAssertEqual(_model.stringValue, @"HelloSuperClass", @"Model stringValue should be HelloSuperClass");
}

#pragma mark Test property dateValue
- (void)testDateValue
{
    NSTimeInterval since1970 = [NSDate date].timeIntervalSince1970;
    
    XCTAssertEqualWithAccuracy(_model.dateValue.timeIntervalSince1970, since1970, 0.01, @"Model dataValue should be time since 1970");
}

@end
