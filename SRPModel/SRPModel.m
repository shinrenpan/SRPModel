//
// Copyright (c) 2016 shinren.pan@gmail.com
//

#import "SRPModel.h"
#import <objc/runtime.h>

// Encode / Decode Key
static NSString *const SRPModelNSCodingKey = @"SRPModelNSCodingKey";


@implementation SRPModel

#pragma mark - Class methods
#pragma mark Models from NSArray
+ (NSArray<SRPModel *> *)modelsFromArray:(NSArray *)array
{
    if(![array isKindOfClass:[NSArray class]] || !array.count)
    {
        return nil;
    }
    
    __block NSMutableArray *results = [NSMutableArray arrayWithCapacity:array.count];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        id model = [self modelFromDictionary:obj];
        
        if(!model || ![model isKindOfClass:[SRPModel class]])
        {
            results = nil;
            *stop   = YES;
        }
        
        [results addObject:model];
    }];
    
    return results;
}

#pragma mark Models from JSON String
+ (NSArray<SRPModel *> *)modelsFromJSONString:(NSString *)json
{
    if(![json isKindOfClass:[NSString class]] || !json.length)
    {
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    if(!jsonData.length)
    {
        return nil;
    }
    
    id jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingAllowFragments
                                                     error:nil];
    
    return [self modelsFromArray:jsonArray];
}

#pragma mark Model from NSDictionary
+ (instancetype)modelFromDictionary:(NSDictionary *)dic
{
    if(![dic isKindOfClass:[NSDictionary class]] || !dic.count)
    {
        return nil;
    }
    
    id result = [[self alloc]init];
    
    if([[self class]respondsToSelector:@selector(defaultKeysValues)])
    {
        NSDictionary *defaultValuse = [self defaultKeysValues];
        
        [result setValuesForKeysWithDictionary:defaultValuse];
    }
    
    [result setValuesForKeysWithDictionary:dic];
    
    return result;
}

#pragma mark Model from JSON String
+ (instancetype)modelFromJSONString:(NSString *)json
{
    if(![json isKindOfClass:[NSString class]] || !json.length)
    {
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                 options:NSJSONReadingAllowFragments
                                                   error:nil];
    
    return [self modelFromDictionary:jsonDic];
}

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSString *json = [aDecoder decodeObjectForKey:SRPModelNSCodingKey];
    
    self = [[self class]modelFromJSONString:json];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSString *json = [self toJSONString];
    
    [aCoder encodeObject:json forKey:SRPModelNSCodingKey];
}

#pragma mark - NSKeyValueCoding
- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if(![keyedValues isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    // 如果有實作 mapping, 先設置 mapping 的 key / value.
    if([[self class]respondsToSelector:@selector(keyMapping)])
    {
        NSDictionary *mapping = [[self class]keyMapping];
        
        [mapping enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            id value = keyedValues[key];
            
            [self __setValue:value forKey:obj];
        }];
    }
    
    // 將本身 Key 跟 mapping allkeys 做 NSSet intersect,
    // 取出共有的 key, 再設置 value, 可加速設置過程.
    NSSet *properties  = [self __allProperties];
    NSMutableSet *keys = [NSMutableSet setWithArray:[keyedValues allKeys]];
    
    [keys intersectSet:properties];
    
    NSArray *set = [keys allObjects];
    
    for(NSString *key in set)
    {
        id value = keyedValues[key];
        
        [self __setValue:value forKey:key];
    }
}

#pragma mark - NSObject
- (NSString *)description
{
    return [self debugQuickLookObject];
}

#pragma mark - Debug Look
- (id)debugQuickLookObject
{
    return [self toJSONString];
}

#pragma mark - Piblic
#pragma mark To NSDictionary
- (NSDictionary *)toDictionary
{
    NSSet *properties = [self __allProperties];
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:properties.count];
    
    for(NSString *property in properties)
    {
        id value = [self valueForKey:property];
        
        if(!value)
        {
            value = [NSNull null];
        }
        
        if([value isKindOfClass:[SRPModel class]])
        {
            value = [value toDictionary];
        }
        
        // 如果 value 為 NSArray, 需要再把 Array 裡的 object 再轉換.
        if([value isKindOfClass:[NSArray class]])
        {
            NSMutableArray *newValue = [NSMutableArray array];
            
            [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                if([obj isKindOfClass:[SRPModel class]])
                {
                    obj = [obj toDictionary];
                }
                
                [newValue addObject:obj];
            }];
            
            value = newValue;
        }
        
        result[property] = value;
    }
    
    return result;
}

#pragma mark To JSON String
- (NSString *)toJSONString
{
    NSDictionary *dic = [self toDictionary];
    NSData *jsonData  = [NSJSONSerialization dataWithJSONObject:dic
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];
    
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}


#pragma mark - Private
#pragma mark 設置 Key / Value
- (void)__setValue:(id)value forKey:(NSString *)key
{
    if([value isKindOfClass:[NSNull class]] || !value)
    {
        return;
    }
    
    Class propertyClass = [self __classForProperty:key];
    
    // 如果某個 key 的 class 等於 SRPModel, 而且 value 是 NSDictionary, 再把 value 轉成 SRPModel.
    if([value isKindOfClass:[NSDictionary class]] &&
       [propertyClass isSubclassOfClass:[SRPModel class]])
    {
        value = [propertyClass modelFromDictionary:value];
    }
    
    // 如果某個自定義 SRPModel 實作 Protol arrayToModels:forKey:,
    // 而且 vaule 為 NSArray, 再把 value 轉成 SRPModel 集合.
    if([value isKindOfClass:[NSArray class]] &&
       [[self class] respondsToSelector:@selector(arrayToModels:forKey:)])
    {
        value = [[self class]arrayToModels:value forKey:key];
    }
    
    // value 為空, 或是 value class 與 property class 不符合
    if(!value || ![value isKindOfClass:propertyClass])
    {
        return;
    }
    
    [self setValue:value forKey:key];
}

#pragma mark 返回 properties
- (NSSet *)__allProperties
{
    NSMutableSet *result = [NSMutableSet set];
    Class class = [self class];
    
    // 這裡會返回包含 Super class property
    while ([class isSubclassOfClass:[SRPModel class]])
    {
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList(class, &count);;
        NSString *propertyName;
        
        for(unsigned int i = 0; i < count; i++)
        {
            propertyName = @(property_getName(propertyList[i]));
            
            if(propertyName.length)
            {
                [result addObject:propertyName];
            }
        }
        
        free(propertyList);
        
        class = [class superclass];
    }
        
    return result.count ? result : nil;
}

#pragma mark 返回某個 Property 的 class 類型
- (Class)__classForProperty:(NSString *)key
{
    Class class;
    
    objc_property_t property = class_getProperty([self class], key.UTF8String);
    
    if(property == NULL)
    {
        return NULL;
    }
    
    // 以 NSString 為例
    // "T@\"NSString\",R,N,V_property"
    const char *type = property_getAttributes(property);
    
    // T@"NSString",R,N,V_property
    NSString * typeString = @(type);
    
    //@[@"T@"NSString", @"R", @"N", @"V_property"]
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    
    // T@"NSString
    NSString * typeAttribute = [attributes objectAtIndex:0];
    
    // 注意: 不處理 id 類型, property 請不要使用 id
    // Object 類型
    if([typeAttribute hasPrefix:@"T@"])
    {
        NSRange range            = NSMakeRange(3, [typeAttribute length]-4);
        NSString * typeClassName = [typeAttribute substringWithRange:range]; // NSString
        class                    = NSClassFromString(typeClassName);
    }
    
    // NSInteger, int, float, BOOL ...等數值類型, 都直接轉成 NSNumber class
    else
    {
        class = [NSNumber class];
    }
    
    return class;
}

@end
