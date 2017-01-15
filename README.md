# SRPModel #
簡單利用 KVC 將 JSON String, NSDictionary 轉換成 Model.  
將 JSON Array String, NSArray 轉換成 Model 集合.



## 安裝 ##
使用 [Carthage] 安裝, 或是將 SRPModel 目錄加入專案.

[Carthage]: https://github.com/Carthage/Carthage


## 使用 ##
例如:

```objc
@interface Person: SRPModel
@property (nonatomic, readonly) NSInteger age;
@property (nonatomic, readonly) NSString *name;
@end

@implementation Person
@end
```

透過 `NSDictionary`

```objc
NSDictionary *dic = @{@"age" : @37, @"name" : @"Joe"};
Person *person = [Person modelFromDictionary:dic];

```

透過 `JSON String`

```objc
NSString *JSON = @"{\"age\" : \"37\", \"name\" : \"Joe\"}";
Person *person = [Person modelFromJSONString:JSON];
```

透過 NSArray 或是 JSON Array String 轉換成 Model 集合.

```objc
NSArray *person = @[
                    @{@"age" : @37, @"name" : @"Joe"},
                    @{@"age" : @20, @"name" : @"Mary"}
                   ];

NSArray <Person *> *models = [Person modelsFromArray:person];
```

> JSON Array 實作方法相同, 來源改成 JSON Array `[Person modelsFromJSONString:JSON];`


## 客製化 ##
透過 SRPModelProtocol 可簡單客製化 Model, 包含:

- 自定義 Key mapping.
- 設置 default 值.
- 轉換 Property value



### Key Mapping
假設 Model 一樣為 Person, 但是 API 返回的格式是:

```json
{
	"p_name" : "Joe",
	"age" : 37
}
```

這時就要 Mapping `name`, 在 Implementation 實現 keyMapping Class method.

```objc
@implementation Person
+ (NSDictionary <NSString *, NSString *> *)keyMapping;
{
	return @{@"p_name" : @"name"};
}
@end
```


### Default Value ##
設置 Default 必須實作 defaultKeysValues Class method.  
例如:

```objc
@implementation Person
+ (NSDictionary *)defaultKeysValues
{
    return @{@"age" : @10};
}
@end
```

> 注意: 假設 Default age = 10, Call API 返回的 JSON 有 age 值, Default 值會被 API 值蓋過.



### 轉換 Property value
假設 Person 有個 Property models 是 SRPModel 集合, 如下, 必須實作 (propertyName)TransformValue Class method

```objc
@property (nonatomic, readonly) NSArray <SomeModel *> *models;
.
.
.

@implementation Person
+ (NSArray *)modelsTransformValue:(id)oldValue
{
	if([oldValue isKindOfClass:[NSArray class]])
	{
		return [SomeModel modelsFromArray:oldValue];
	}
	
	return nil;
}
@end
```

