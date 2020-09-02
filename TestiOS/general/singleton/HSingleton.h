//
//  HSingleton.h
//  TestiOS
//
//  Created by gyh on 2020/9/2.
//  Copyright © 2020 com.berman.www. All rights reserved.
//
 
// ## : 起拼接作用
// \  : 取消换行

// .h文件的实现
#define SingletonH(methodName) + (instancetype)shared##methodName;

// .m文件的实现
// 最后一行不能加反斜杠
#if __has_feature(objc_arc) // ARC
#define SingletonM(methodName) \
static id _instance = nil; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
    if (_instance == nil) { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _instance = [super allocWithZone:zone]; \
        }); \
    } \
    return _instance; \
} \
\
- (instancetype)init { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super init]; \
    }); \
    return _instance; \
} \
\
+ (instancetype)shared##methodName { \
    return [[self alloc] init]; \
} \
\
+ (id)copyWithZone:(struct _NSZone *)zone { \
return _instance; \
} \
\
+ (id)mutableCopyWithZone:(struct _NSZone *)zone { \
return _instance; \
}
#else   // 非ARC
#define SingletonM(methodName) \
static id _instance = nil; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
if (_instance == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
} \
return _instance; \
} \
\
- (instancetype)init { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super init]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##methodName { \
return [[self alloc] init]; \
}\
\
- (oneway void)release { \
} \
\
- (instancetype)retain { \
return self; \
} \
\
- (NSUInteger)retainCount { \
return 1; \
} \
 \
+ (id)copyWithZone:(struct _NSZone *)zone { \
    return _instance; \
} \
 \
+ (id)mutableCopyWithZone:(struct _NSZone *)zone { \
    return _instance; \
}

#endif
