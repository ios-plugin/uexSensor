//
//  EUExSensorMgr.h
//  webKitCorePalm
//
//  Created by zywx on 11-9-7.
//  Copyright 2011 3g2win. All rights reserved.
//

#import "EUExBase.h"
#import "Sensor.h"

enum uexSensorTypesID {
	F_SENSOR_TYPE_ACCELEROMETER	= 1,
	F_SENSOR_TYPE_ORIENTATION,
	F_SENSOR_TYPE_MAGNETIC_FIELD,
	F_SENSOR_TYPE_TEMPERATURE,
	F_SENSOR_TYPE_PRESSURE,
	F_SENSOR_TYPE_LIGHT 	   				
};
enum uexSensorRateID {
	F_SENSOR_RATE_FASTEST	= 1,
	F_SENSOR_RATE_GAME,
	F_SENSOR_RATE_UI,
	F_SENSOR_RATE_NORMAL	   				
};
@interface EUExSensor : EUExBase {
	NSMutableDictionary *methodDict;
	Sensor *sensorObj;
}
-(void)uexSensorWithType:(int)inType sensorX:(float)inSensorX sensorY:(float)inSensorY sensorZ:(float)inSensorZ;

@end
