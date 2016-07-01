//
//  Sensor.h
//  WebKitCorePlam
//
//  Created by yang fan on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
@class EUExSensor;
@interface Sensor : NSObject <CLLocationManagerDelegate>{
	CMMotionManager *motionManager;
	
	CLLocationManager *gpsManager;
}

@property (nonatomic, assign) EUExSensor * euexObj;



//-(void)initSensorWithUExObj:(EUExSensor *)euexObj_;
-(void)openMotation;
-(void)openMagnetic;
-(void)closeMagneticSensor;
-(void)closeAccelerSensor;
-(void)closeAllSensor;
@end
