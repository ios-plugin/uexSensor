//
//  Sensor.m
//  WebKitCorePlam
//
//  Created by yang fan on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "EUtility.h"
#import "Sensor.h"
#import "EUExSensor.h"
@implementation Sensor
-(void)initSensorWithUExObj:(EUExSensor *)euexObj_ {
	 euexObj = euexObj_;
}

-(void)openMotation{
 
	if (motionManager) {
		 return;
	 }
	 motionManager = [[CMMotionManager alloc] init];
 
	NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
	if (motionManager.accelerometerAvailable) {
		motionManager.accelerometerUpdateInterval = 0.1;
		[motionManager startAccelerometerUpdatesToQueue:queue withHandler:
		 ^(CMAccelerometerData *accelerometerData, NSError *error){
		 if (error) {
			 [motionManager stopAccelerometerUpdates];
			 PluginLog(@"update error = %@",error);
 		 }else {
			 NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:accelerometerData.acceleration.x],[NSNumber numberWithFloat:accelerometerData.acceleration.y],[NSNumber numberWithFloat:accelerometerData.acceleration.z],nil];
			 [self performSelectorOnMainThread:@selector(sendDataToJS:) withObject:array waitUntilDone:YES];
		 }
		 } ];
	}
}
-(void)sendDataToJS:(NSArray *)array{
	float x = [[array objectAtIndex:0] floatValue];
	float y = [[array objectAtIndex:1] floatValue];
	float z = [[array objectAtIndex:2] floatValue];
	PluginLog(@"x,y,z = %f---%f---%f",x,y,z);
	[euexObj uexSensorWithType:F_SENSOR_TYPE_ACCELEROMETER sensorX:x*10 sensorY:y*10 sensorZ:z*10];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{	
	NSString *xStr = [NSString stringWithFormat:@"%f",newHeading.x];
	NSString *yStr = [NSString stringWithFormat:@"%f",newHeading.y];
	NSString *zStr = [NSString stringWithFormat:@"%f",newHeading.z];
 	PluginLog(@"x,y,z:%@\n%@\n%@",xStr,yStr,zStr);
	[euexObj uexSensorWithType:F_SENSOR_TYPE_MAGNETIC_FIELD sensorX:newHeading.x sensorY:newHeading.y sensorZ:newHeading.z];
}
-(void)openMagnetic{
	if (gpsManager) {
		return;
	}
	gpsManager = [ [ CLLocationManager alloc] init];
	gpsManager.delegate = self;
	gpsManager.desiredAccuracy = kCLLocationAccuracyBest;
	gpsManager.distanceFilter = kCLDistanceFilterNone;
//	gpsManager.headingFilter = 2.0f;       //设置此变量试试？
	[gpsManager startUpdatingHeading];
}
-(void)closeAccelerSensor{
	if (motionManager) {
		[motionManager stopAccelerometerUpdates];
		[motionManager release];
		 motionManager=nil;
	}
}
-(void)closeMagneticSensor{
	if (gpsManager) {
		[gpsManager stopUpdatingHeading];
		[gpsManager release];
		gpsManager = nil;
	}
}
-(void)closeAllSensor{
	[self closeMagneticSensor];
	[self closeAccelerSensor];
}
-(void)dealloc{
	if (motionManager) {
		[motionManager release];
		motionManager=nil;
	}
	if (gpsManager) {
		[gpsManager release];
		gpsManager = nil;
	}
    [super dealloc];
}
@end
