// Generated by Apple Swift version 3.1 (swiftlang-802.0.53 clang-802.0.42)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if defined(__has_attribute) && __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import AVFoundation;
@import Foundation;
@import QuartzCore;
@import ObjectiveC;
@import CRToast;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

@interface AVAsset (SWIFT_EXTENSION(CHPlugin))
@end


@interface AVMetadataFaceObject (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSBundle (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSBundle (SWIFT_EXTENSION(CHPlugin))
@end


@interface CALayer (SWIFT_EXTENSION(CHPlugin))
@end

@class NSAttributedString;

SWIFT_CLASS("_TtC8CHPlugin18CHAttributedString")
@interface CHAttributedString : NSObject
@property (nonatomic) NSError * _Nullable error;
@property (nonatomic, readonly, strong) NSAttributedString * _Nonnull string;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


@interface CRToastManager (SWIFT_EXTENSION(CHPlugin))
@end


SWIFT_PROTOCOL("_TtP8CHPlugin20ChannelBadgeDelegate_")
@protocol ChannelBadgeDelegate
/// notify badge count when changed
- (void)badgeDidChangedWithCount:(NSInteger)count;
@end

/// Checkin result state
/// <ul>
///   <li>
///     success: Checkin success
///   </li>
///   <li>
///     notInitialized: PluginKey is not initialized
///   </li>
///   <li>
///     networkTimeout: Network request timeout
///   </li>
///   <li>
///     duplicated: already checkin
///   </li>
///   <li>
///     notAvailableVersion: SDK version is not compatible
///   </li>
///   <li>
///     serviceUnderConstruction: server is out of service
///   </li>
///   <li>
///     checkinError: any other errors
///   </li>
/// </ul>
typedef SWIFT_ENUM(NSInteger, ChannelCheckinCompletionStatus) {
  ChannelCheckinCompletionStatusSuccess = 0,
  ChannelCheckinCompletionStatusNotInitialized = 1,
  ChannelCheckinCompletionStatusNetworkTimeout = 2,
  ChannelCheckinCompletionStatusDuplicated = 3,
  ChannelCheckinCompletionStatusNotAvailableVersion = 4,
  ChannelCheckinCompletionStatusServiceUnderConstruction = 5,
  ChannelCheckinCompletionStatusCheckinError = 6,
};

@class Checkin;

SWIFT_CLASS("_TtC8CHPlugin13ChannelPlugin")
@interface ChannelPlugin : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, weak) id <ChannelBadgeDelegate> _Nullable badgeDelegate;)
+ (id <ChannelBadgeDelegate> _Nullable)badgeDelegate SWIFT_WARN_UNUSED_RESULT;
+ (void)setBadgeDelegate:(id <ChannelBadgeDelegate> _Nullable)value;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL debugMode;)
+ (BOOL)debugMode SWIFT_WARN_UNUSED_RESULT;
+ (void)setDebugMode:(BOOL)value;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL hideLauncherButton;)
+ (BOOL)hideLauncherButton SWIFT_WARN_UNUSED_RESULT;
+ (void)setHideLauncherButton:(BOOL)value;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL isVisible;)
+ (BOOL)isVisible SWIFT_WARN_UNUSED_RESULT;
+ (void)setIsVisible:(BOOL)value;
/// Initalize channel plugin.
/// This method has to be called prior to any other methods
/// provided by channel plugin
/// \param pluginKey plugin key from Channel io
///
+ (void)initializeWithPluginKey:(NSString * _Nonnull)pluginKey;
/// Register a push token.
/// This method has to be called within
/// <code>application:didRegisterForRemoteNotificationsWithDeviceToken:</code>
/// in <code>AppDelegate</code> in order to get receive push notification from Channel io
/// \param token a Data that represents device token
///
+ (void)registerWithDeviceToken:(NSData * _Nonnull)deviceToken;
/// Check in channel io
/// Call this method first in order to start using any chatting feature
/// \param checkinObj Checkin object contains necessary information
///
/// \param completion Completion callback block
///
+ (void)checkIn:(Checkin * _Nullable)checkinObj completion:(void (^ _Nullable)(enum ChannelCheckinCompletionStatus))completion;
/// Check out from channel
/// Call this method when user terminate session or logout
+ (void)checkOutWithReinit:(BOOL)reinit;
/// Show channel launcher view on application
/// location of the view can be customized in Channel Desk
/// \param animated if true, the view is being added to the window using an animation
///
+ (void)showLauncherWithAnimated:(BOOL)animated;
/// Hide channel launcher view from application
/// \param animated if true, the view is being added to the window using an animation
///
+ (void)hideLauncherWithAnimated:(BOOL)animated;
/// \code
///  Show channel messenger on application
///
///  - parameter animated: if true, the view is being added to the window using an animation
///
/// \endcode
+ (void)showWithAnimated:(BOOL)animated;
/// Hide channel messenger from application
/// \param animated if true, the view is being added to the window using an animation
///
+ (void)hideWithAnimated:(BOOL)animated;
/// Check whether push notification is valid Channel push notification
/// by inspecting userInfo
/// \param userInfo a Dictionary contains push information
///
+ (BOOL)isChannelNotification:(NSDictionary * _Nonnull)userInfo SWIFT_WARN_UNUSED_RESULT;
/// Handle push notification for channel
/// This method has to be called within <code>userNotificationCenter:response:completionHandler:</code>
/// for <em>iOS 10 and above</em>, and <code>application:userInfo:completionHandler:</code>
/// for <em>other version of iOS</em> in <code>AppDelegate</code> in order to make channel
/// plugin worked properly
/// \param userInfo a Dictionary contains push information
///
+ (void)handlePushNotification:(NSDictionary * _Nonnull)userInfo;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface ChannelPlugin (SWIFT_EXTENSION(CHPlugin))
@end


SWIFT_CLASS("_TtC8CHPlugin7Checkin")
@interface Checkin : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (Checkin * _Nonnull)withName:(NSString * _Nonnull)name;
- (Checkin * _Nonnull)withUserId:(NSString * _Nonnull)userId;
- (Checkin * _Nonnull)withAvatarUrl:(NSString * _Nonnull)avatarUrl;
- (Checkin * _Nonnull)withMobileNumber:(NSString * _Nonnull)mobileNumber;
- (Checkin * _Nonnull)withMetaKey:(NSString * _Nonnull)metaKey metaValue:(id _Nonnull)metaValue;
@end


@interface NSArray (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSData (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSDictionary (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSDictionary (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSNull (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSNumber (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSNumber (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSObject (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSObject (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSRecursiveLock (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSString (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSThread (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIButton (SWIFT_EXTENSION(CHPlugin))
@end


@interface UICollectionView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UICollectionView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIColor (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIImage (SWIFT_EXTENSION(CHPlugin))
@end


@interface UILayoutGuide (SWIFT_EXTENSION(CHPlugin))
@end


@interface UILayoutGuide (SWIFT_EXTENSION(CHPlugin))
@end


@interface UILayoutGuide (SWIFT_EXTENSION(CHPlugin))
@end


@interface UINavigationController (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIScrollView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UITableView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UITableView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIView (SWIFT_EXTENSION(CHPlugin))
@end


@interface UIViewController (SWIFT_EXTENSION(CHPlugin))
@end


@interface NSURLSession (SWIFT_EXTENSION(CHPlugin))
@end

#pragma clang diagnostic pop
