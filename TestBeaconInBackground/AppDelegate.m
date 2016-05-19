//
//  AppDelegate.m
//  TestBeaconInBackground
//
//  Created by dean on 2016/5/19.
//  Copyright © 2016年 dean. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
    
    [app registerUserNotificationSettings:settings];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
    }
    NSLog(@"applicationDidFinishLaunching");

    
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;//記得要設置delegate
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    
    //Prepare BeaconRegions
    
    
    NSUUID *beacon1UUID = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    
    
    beaconRegion1 = [[CLBeaconRegion alloc] initWithProximityUUID:beacon1UUID identifier:@"com.beacon1"];
    beaconRegion1.notifyOnEntry = true;
    beaconRegion1.notifyOnExit = true;
    beaconRegion1.notifyEntryStateOnDisplay = YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [locationManager startMonitoringForRegion:beaconRegion1];
    [locationManager startRangingBeaconsInRegion:beaconRegion1];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [locationManager stopMonitoringForRegion:beaconRegion1];
    
    
    [locationManager stopRangingBeaconsInRegion:beaconRegion1];

    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - CLLocationManagerDelegate methods
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    // See if we've entered the region.
    
        UILocalNotification * notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"didEnterRegion";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    [locationManager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    // See if we've exited a treasure region.
    
        UILocalNotification * notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"didExitRegion";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    [locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
//    if (![region.identifier isEqualToString:treasureId])
//        return;
    
    NSString *message;
    
    switch (state) {
        case CLRegionStateUnknown:{
            
            UILocalNotification * notification = [[UILocalNotification alloc] init];
            message = @"你...在哪裡";
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            break;
        }
        case CLRegionStateInside:{
            UILocalNotification * notification = [[UILocalNotification alloc] init];
            message = @"你在iBeacon的範圍裡";
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            break;
        }
        case CLRegionStateOutside:
        {
            UILocalNotification * notification = [[UILocalNotification alloc] init];
            message = @"你在iBeacon的範圍外面";
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            break;
        }
    }
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
    UILocalNotification * notification2 = [[UILocalNotification alloc] init];
    notification2.alertBody = @"didRangeBeacons";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification2];
    
    if ([beacons count] == 0)
        return;
    
    // beacons is a list of beacons in proximity order. That is, the first beacon in the list will be the nearest to you.
    CLBeacon * beacon = [beacons firstObject];
    NSString * message;
    
    //    NSLog(@"beacon: %@", beacon);
    switch (beacon.proximity) {
        case CLProximityUnknown:
            message = @"Unknown";
            break;
        case CLProximityFar:
            message = @"Far";
            break;
        case CLProximityNear:
            message = @"Near";
            break;
        case CLProximityImmediate:
            message = @"Immediate";
            break;
    }
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end
