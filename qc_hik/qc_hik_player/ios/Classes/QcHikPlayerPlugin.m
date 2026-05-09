#import "QcHikPlayerPlugin.h"
#import "QcHikPlayerFactory.h"

@implementation QcHikPlayerPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  QcHikPlayerFactory *factory = [[QcHikPlayerFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:factory withId:@"qc_hik_player_view"];
}

@end
