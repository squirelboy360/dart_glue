import 'dart:io';

class IosProjectTemplate {
  Future<void> createXcodeProject(Directory iosDir) async {
    await iosDir.create(recursive: true);

    // Use xcodebuild to create base project
    await Process.run('xcodebuild', [
      '-create',
      '-project',
      '${iosDir.path}/DartGlue.xcodeproj',
      '-target',
      'DartGlue',
      '-configuration',
      'Debug'
    ]);

    // Initialize CocoaPods
    await Process.run('pod', ['init'], workingDirectory: iosDir.path);

    // Add bridge files to existing Xcode project
    await _createBridgeFiles(iosDir);
    await _updatePodfile(iosDir);
    await _updateWorkspace(iosDir);
  }

  Future<void> _createBridgeFiles(Directory iosDir) async {
    final bridgeDir = Directory('${iosDir.path}/DartGlue/Bridge');
    await bridgeDir.create(recursive: true);

    // Create bridge header
    await File('${bridgeDir.path}/DNBridge.h').writeAsString('''
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DNBridge : NSObject

+ (instancetype)sharedInstance;
- (void)createView:(NSString *)viewId withProps:(NSDictionary *)props;
- (void)createText:(NSString *)viewId withProps:(NSDictionary *)props;
- (void)createButton:(NSString *)viewId withProps:(NSDictionary *)props;
- (void)createImage:(NSString *)viewId withProps:(NSDictionary *)props;

@end
''');

    // Create bridge implementation
    await File('${bridgeDir.path}/DNBridge.mm').writeAsString('''
#import "DNBridge.h"

@implementation DNBridge {
    NSMutableDictionary<NSString *, UIView *> *_viewRegistry;
    UIView *_rootView;
}

+ (instancetype)sharedInstance {
    static DNBridge *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DNBridge alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _viewRegistry = [NSMutableDictionary new];
        _rootView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return self;
}

// View creation methods
- (void)createView:(NSString *)viewId withProps:(NSDictionary *)props {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [[UIView alloc] init];
        [self configureView:view withProps:props];
        self->_viewRegistry[viewId] = view;
        [self->_rootView addSubview:view];
    });
}

- (void)createText:(NSString *)viewId withProps:(NSDictionary *)props {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *label = [[UILabel alloc] init];
        label.text = props[@"text"];
        [self configureView:label withProps:props];
        self->_viewRegistry[viewId] = label;
        [self->_rootView addSubview:label];
    });
}

- (void)createButton:(NSString *)viewId withProps:(NSDictionary *)props {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:props[@"text"] forState:UIControlStateNormal];
        [self configureView:button withProps:props];
        self->_viewRegistry[viewId] = button;
        [self->_rootView addSubview:button];
    });
}

- (void)createImage:(NSString *)viewId withProps:(NSDictionary *)props {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *imageView = [[UIImageView alloc] init];
        NSURL *imageURL = [NSURL URLWithString:props[@"source"]];
        // TODO: Add image loading logic
        [self configureView:imageView withProps:props];
        self->_viewRegistry[viewId] = imageView;
        [self->_rootView addSubview:imageView];
    });
}

// Helper methods
- (void)configureView:(UIView *)view withProps:(NSDictionary *)props {
    NSDictionary *style = props[@"style"];
    if (style) {
        if (style[@"backgroundColor"]) {
            view.backgroundColor = [self colorFromHexString:style[@"backgroundColor"]];
        }
        // Add more style processing
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                          green:((rgbValue & 0xFF00) >> 8)/255.0
                           blue:(rgbValue & 0xFF)/255.0
                          alpha:1.0];
}

@end
''');
  }

  Future<void> _updatePodfile(Directory iosDir) async {
    await File('${iosDir.path}/Podfile').writeAsString('''
platform :ios, '13.0'

target 'DartGlue' do
  use_frameworks!
  
  # Add your pods here
end
''');

    // Run pod install
    await Process.run('pod', ['install'], workingDirectory: iosDir.path);
  }

  Future<void> _updateWorkspace(Directory iosDir) async {
    // Update project settings through xcodebuild
    await Process.run('xcodebuild', [
      '-project',
      '${iosDir.path}/DartGlue.xcodeproj',
      '-target',
      'DartGlue',
      '-configuration',
      'Debug',
      'BUILD_DIR=build'
    ]);
  }
}
