//
//  SmartTravelPillow.h
//  SmartTravelPillow
//
//  Created by BB9z on 2019/10/11.
//  Copyright © 2019 浩雨科技. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 SDK 主要接口
 */
@interface SmartTravelPillow : NSObject

#pragma mark - 配置

/**
 注册 SDK

 请在 `application:didFinishLaunchingWithOptions:` 调用

 @param appID 不可为空
 @param launchOptions `didFinishLaunchingWithOptions` 的启动信息
 */
+ (void)setupWithAppID:(nonnull NSString *)appID luanchOption:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions NS_SWIFT_NAME( setup(appID:luanchOption:) );

/**
 用户标示符

 SDK 用该标识符存取用户的报告，在进入 SDK 页面前需要设置。用户登出时可以置空

 推荐在 app 后台用户创建时生成一个足够长的 UUID 作为用户标识符，app 接口获取用户信息后再将该 UUID 作为用户标识符传给 SDK。常见不安全的标识符方案：设备 ID、后台自增 ID、用户手机号
 */
@property (class, nullable) NSString *userIdentifier;

/**
 已设置的 App ID
 */
@property (class, readonly, nullable) NSString *appID;

/**
 App ID 的有效期

 App 可以利用该属性控制 SDK 入口的显隐，值变化时会发送 `HYSDKAppIDExpireChanged` 通知

 除了正常值外，NSDate.distantPast 意味着当前 App ID 是无效的；如果为空可以正常使用 SDK 功能
 */
@property (class, readonly, nullable) NSDate *appIDExpire;

#pragma mark - 外观控制

/**
 默认 SDK 控件文字颜色为白色

 SDK 页面主题色随 window 的 tintColor，如果颜色较浅时需将该属性置为 YES
 */
@property (class, getter=isContolUsingDarkText) BOOL contolUsingDarkText;

/**
 SDK 页面导航的背景色
 */
@property (class, nullable) UIColor *navigationBarBackgroundColor;

/**
 SDK 页面导航的标题及 item 颜色
 */
@property (class, nullable) UIColor *navigationBarItemColor;

/**
 显示 SDK 页面时状态栏的样式
 */
@property (class) UIStatusBarStyle statusBarStyle;

#pragma mark - 跳转

typedef NS_ENUM(NSInteger, HYJumpScenesError) {
    /// SDK app ID 未设置或不是正确的 app ID
    HYJumpScenesErrorAppIDInvaild = 101,

    /// App ID 使用已超期
    HYJumpScenesErrorAppIDExpired,

    /// 用户标示符未设置，进入 SDK 页面前需要设置
    HYJumpScenesErrorUserIDNotSet,

    /// 跳转传入的参数有误
    HYJumpScenesErrorInvaildOption,
};

/**
 判断能否正常进入 SDK 页面

 当配置不当或 App ID 超期，跳转到 SDK 页面也不能正常工作，app 端可以在跳转前做下检查

 注意随着时间推移返回值可能会变

 @param error 错误指针，错误码见 `HYJumpScenesError`，一切正常指针内容为空
 */
+ (BOOL)canPresentSDKScenesError:(NSError *__nullable *__nullable)error __attribute__((swift_error(none)));

typedef NSString * HYJumpScenesOptionsKey NS_TYPED_ENUM;
/// 传健康报告的 ID，非空的话直接跳转到指定报告页
FOUNDATION_EXPORT HYJumpScenesOptionsKey const __nonnull HYJumpScenesOptionsReportIDKey;
/// 当 App ID 超期、不正确等情况时默认会跳转到失败页，若想完全自己处理不跳页，需置为 YES
/// 传 NSNumber 包装的 BOOL，默认 NO
FOUNDATION_EXPORT HYJumpScenesOptionsKey const __nonnull HYJumpScenesOptionsNoJumpWhenFailsKey;
/// 弹出不显示返回按钮
FOUNDATION_EXPORT HYJumpScenesOptionsKey const __nonnull HYJumpScenesOptionsNoDismissKey;

/**
 跳转到 SDK 的页面

 注意可能不会立即执行跳转，可能会等待一段时间，同时还可能出错不会跳转

 @param viewController SDK 页面将从该页面弹出，如果传空，会自动找一个可以弹出的 view controller
 @param options 可选跳转参数，参见 HYJumpScenesOptionsKey
 @param complation 跳转完成后调用，总是在主线程调用。跳转成功 error 为空，错误码见 `HYJumpScenesError`
 */
+ (void)presentSDKScenesFromViewController:(nullable UIViewController *)viewController options:(nullable NSDictionary<HYJumpScenesOptionsKey, id> *)options complation:(nullable void(^)(NSError *__nullable error))complation;

/**
 版本信息

 一般用于调试展示，如需版本判断推荐用 `SmartTravelPillowVersionNumber`
 */
@property (class, readonly, nonnull) NSString *versionDescription;

@end

/// SDK 错误的 error domain
FOUNDATION_EXPORT const NSErrorDomain __nonnull HYSDKErrorDomain;

/// appIDExpire 属性变化时发出的通知，总是在主线程
FOUNDATION_EXPORT const NSNotificationName __nonnull HYSDKAppIDExpireChanged;

/// 健康检测结束时发出
FOUNDATION_EXPORT const NSNotificationName __nonnull HYSDKHealthMonitoringHasEnded;

//! Project version number for SmartTravelPillow.
/// SDK Build count，即 CFBundleVersion
FOUNDATION_EXPORT double SmartTravelPillowVersionNumber;

//! Project version string for SmartTravelPillow.
FOUNDATION_EXPORT const unsigned char SmartTravelPillowVersionString[];
