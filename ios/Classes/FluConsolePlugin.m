#import "FluConsolePlugin.h"
#if __has_include(<flu_console/flu_console-Swift.h>)
#import <flu_console/flu_console-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flu_console-Swift.h"
#endif

@implementation FluConsolePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFluConsolePlugin registerWithRegistrar:registrar];
}
@end
