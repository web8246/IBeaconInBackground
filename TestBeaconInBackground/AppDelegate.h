//
//  AppDelegate.h
//  TestBeaconInBackground
//
//  Created by dean on 2016/5/19.
//  Copyright © 2016年 dean. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager * locationManager;
    CLBeaconRegion * beaconRegion1;
}

@property (strong, nonatomic) UIWindow *window;


@end

