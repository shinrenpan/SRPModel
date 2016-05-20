// SRPModel.m
//
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

#import "SRPModel.h"
#import <objc/runtime.h>


@implementation SRPModel

#pragma mark - Class methods
#pragma mark Models from NSArray
+ (NSArray *)modelsFromArray:(NSArray *)array
{
    if(![array isKindOfClass:[NSArray class]] || !array.count)
    {
        return nil;
    }
    
    __block NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id model = [self modelFromDictionary:obj];
        
        if(!model)
        {
            result = nil;
            *stop  = YES;
        }
        
        [result addObject:model];
    }];
    
    return result;
}

#pragma mark Models from JSON String
+ (NSArray *)modelsFromJSONString:(NSString *)json
{
    if(![json isKindOfClass:[NSString class]] || !json.length)
    {
        return nil;
    }
    
    NSData *toData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    id object = [NSJSONSerialization JSONObjectWithData:toData
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
    
    return [self modelsFromArray:object];
}

#pragma mark Model from NSDictionary
+ (instancetype)modelFromDictionary:(NSDictionary *)dic
{
    if(![dic isKindOfClass:[NSDictionary class]] || !dic.count)
    {
        return nil;
    }
    
    id object = [[self alloc]init];
    
    [object setValuesForKeysWithDictionary:dic];
    
    return object;
}

#pragma mark Model from JSON String
+ (instancetype)modelFromJSONString:(NSString *)json
{
    if(![json isKindOfClass:[NSString class]] || !json.length)
    {
        return nil;
    }
    
    NSData *toData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    id object = [NSJSONSerialization JSONObjectWithData:toData
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
    
    return [self modelFromDictionary:object];
}

#pragma mark - NSKeyValueCoding
- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if(![keyedValues isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    // 如果有實作 mapping, 先設置 mapping 的 key / value.
    if([[self class]respondsToSelector:@selector(propertyMapping)])
    {
        NSDictionary *mapping = [[self class]propertyMapping];
        
        [mapping enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id value = keyedValues[key];
            
            [self __setValue:value forKey:obj];
        }];
    }
    
    // 將 self properties 跟 mapping allkeys 做 NSSet intersect,
    // 取出共有的 key, 再設置 value, 可加速設置過程.
    NSSet *properties  = [self __properties];
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
    return [[self toDictionary]description];
}

#pragma mark - Piblic
#pragma mark SRPModel to NSDictionary
- (NSDictionary *)toDictionary
{
    NSSet *properties = [self __properties];
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:properties.count];
    
    for(NSString *property in properties)
    {
        id value = [self valueForKey:property];
        
        if([value isKindOfClass:[SRPModel class]])
        {
            value = [value toDictionary];
        }
        
        // 如果 value 為 NSArray, 需要再把 Array 裡的 object 再轉換.
        if([value isKindOfClass:[NSArray class]])
        {
            NSMutableArray *array = [NSMutableArray array];
            
            [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if([obj isKindOfClass:[SRPModel class]])
                {
                    obj = [obj toDictionary];
                }
                
                [array addObject:obj];
            }];
            
            value = array;
        }
        
        result[property] = value;
    }
    
    return result;
}

#pragma mark SRPModel to JSON string
- (NSString *)toJSON
{
    NSDictionary *dic = [self toDictionary];
    NSData *toData    = [NSJSONSerialization dataWithJSONObject:dic
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];
    
    return [[NSString alloc]initWithData:toData encoding:NSUTF8StringEncoding];
}


#pragma mark - Private
#pragma mark 設置 Key / Value
- (void)__setValue:(id)value forKey:(NSString *)key
{
    if([value isKindOfClass:[NSNull class]])
    {
        return;
    }
    
    Class class = [self __classForProperty:key];
    
    // 如果某個 key 的 class 等於 SRPModel, 而且 value 是 NSDictionary, 再把 value 轉成 SRPModel.
    if([value isKindOfClass:[NSDictionary class]] &&
       [class isSubclassOfClass:[SRPModel class]])
    {
        value = [class modelFromDictionary:value];
    }
    
    // 如果某個自定義 SRPModel 實作 Protol modelsFromArray:forKey:,
    // 而且 vaule 為 NSArray, 再把 value 轉成 SRPModel 集合.
    if([value isKindOfClass:[NSArray class]] &&
       [[self class] respondsToSelector:@selector(newModelsFromArray:forProperty:)])
    {
        value = [[self class]newModelsFromArray:value forProperty:key];
    }
    
    if(!value || ![value isKindOfClass:class])
    {
        return;
    }
    
    [self setValue:value forKey:key];
}

#pragma mark 返回 properties
- (NSSet *)__properties
{
    unsigned int count          = 0;
    NSMutableArray *temp        = [NSMutableArray array];
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for(NSUInteger i = 0; i < count ; i++)
    {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        
        if(propertyName)
        {
            [temp addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
    }
    
    return [NSSet setWithArray:temp];
}

#pragma mark 返回某個 Property 的 class 類型
- (Class)__classForProperty:(NSString *)key
{
    Class class;
    
    objc_property_t property = class_getProperty([self class], key.UTF8String);
    
    if(!property)
    {
        return nil;
    }
    
    const char *type = property_getAttributes(property);
    
    NSString * typeString    = @(type);
    NSArray * attributes     = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    
    // 注意: 不處理 id 類型, property 請不要使用 id
    // Object 類型
    if([typeAttribute hasPrefix:@"T@"])
    {
        NSRange range            = NSMakeRange(3, [typeAttribute length]-4);
        NSString * typeClassName = [typeAttribute substringWithRange:range];
        class                    = NSClassFromString(typeClassName);
    }
    
    // int, float, BOOL 類型
    else
    {
        class = [NSNumber class];
    }
    
    return class;
}

@end