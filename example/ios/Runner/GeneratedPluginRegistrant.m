//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<m3u8_downloader/M3u8DownloaderPlugin.h>)
#import <m3u8_downloader/M3u8DownloaderPlugin.h>
#else
@import m3u8_downloader;
#endif

#if __has_include(<open_file/OpenFilePlugin.h>)
#import <open_file/OpenFilePlugin.h>
#else
@import open_file;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<permission_handler/PermissionHandlerPlugin.h>)
#import <permission_handler/PermissionHandlerPlugin.h>
#else
@import permission_handler;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [M3u8DownloaderPlugin registerWithRegistrar:[registry registrarForPlugin:@"M3u8DownloaderPlugin"]];
  [OpenFilePlugin registerWithRegistrar:[registry registrarForPlugin:@"OpenFilePlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
}

@end
