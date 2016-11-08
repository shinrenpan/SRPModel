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

@end


#pragma mark - Test case
@interface SRPModelTest : XCTestCase

@end


@implementation SRPModelTest

#pragma mark - Test
- (void)testModelFromDictionary
{
    NSDictionary *dic = @{@"cgfloatValue" : @10.1, @"BOOL" : @YES, @"integerValue" : @10, @"stringValue" : @"HelloSuperClass"};
    Model *model      = [Model modelFromDictionary:dic];

    BOOL passCGFloat      = (model.cgfloatValue == 10.1);
    BOOL passBOOL         = (model.boolValue == YES);
    BOOL passDefault      = ([model.defaultValue isEqualToString:@"HellWorld"]);
    BOOL passSuperInteger = (model.integerValue == 10);
    BOOL passSuperString  = ([model.stringValue isEqualToString:@"HelloSuperClass"]);
    
    XCTAssertTrue(passCGFloat && passBOOL && passDefault && passSuperInteger && passSuperString);
}

@end
