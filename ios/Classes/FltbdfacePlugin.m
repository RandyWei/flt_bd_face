#import "FltbdfacePlugin.h"
#if __has_include(<fltbdface/fltbdface-Swift.h>)
#import <fltbdface/fltbdface-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fltbdface-Swift.h"
#endif

@implementation FltbdfacePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFltbdfacePlugin registerWithRegistrar:registrar];
    
    
}
@end
