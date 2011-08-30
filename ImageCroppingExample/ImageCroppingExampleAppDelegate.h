//
//  ImageCroppingExampleAppDelegate.h
//  ImageCroppingExample
//
//  Created by Arjun on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageCroppingExampleViewController;

@interface ImageCroppingExampleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ImageCroppingExampleViewController *viewController;

@end
