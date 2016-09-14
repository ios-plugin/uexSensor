//
//  EUExSensorMgr.m
//  webKitCorePalm
//
//  Created by zywx on 11-9-7.
//  Copyright 2011 3g2win. All rights reserved.
//

#import "EUExSensor.h"
#import "EUtility.h"
#import "EUExBaseDefine.h"

@implementation EUExSensor

//-(id)initWithBrwView:(EBrowserView *) eInBrwView{	
//	if (self = [super initWithBrwView:eInBrwView]) {
//		sensorObj = [[Sensor alloc] init];
//        sensorObj.euexObj = self;
//	}
//	return self;
//}
-(id)initWithWebViewEngine:(id<AppCanWebViewEngineObject>)engine{
    if (self = [super initWithWebViewEngine:engine]) {
        sensorObj = [[Sensor alloc] init];
        sensorObj.euexObj = self;
    }
    return self;
}
-(void)dealloc{
	PluginLog(@"EUExSensor retain count is %d",[self retainCount]);
	PluginLog(@"EUExSensor dealloc is %x", self);
    [self clean];
	[super dealloc];
}

-(void)open:(NSMutableArray *)inArguments {
	PluginLog(@"[EUExSensor open]");
	NSString *inType = [inArguments objectAtIndex:0];
	NSString *inRate = [inArguments objectAtIndex:1];
	if (inType!=nil &&inRate!=nil) {
		int oType = [inType intValue];
		//int oRate = [inRate intValue];
		switch (oType) {
			case F_SENSOR_TYPE_ACCELEROMETER:{
				if (sensorObj) { 
					 [sensorObj openMotation];
				}
				break;
			}		
			case F_SENSOR_TYPE_ORIENTATION:
				//操作同加速度
				break;
			case F_SENSOR_TYPE_MAGNETIC_FIELD:{ //操作
				if (sensorObj) {
                    if([self checkDevice:@"iPod"]){
                        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSensor.onMagneticChange" arguments:ACArgsPack(@(-1),@(-1),@(-1))];
                    }else{
                       [sensorObj openMagnetic]; 
                    }
					 
				}
				break;
			}
			case F_SENSOR_TYPE_TEMPERATURE:
				//操作无api
				break;
			case F_SENSOR_TYPE_PRESSURE:
				//操作无api	
				break;
			case F_SENSOR_TYPE_LIGHT:
				//操作无api
				break;
			default:
				break;
		}
	}
}
-(BOOL)checkDevice:(NSString*)name
{
    NSString* deviceType = [UIDevice currentDevice].model;
    NSLog(@"deviceType = %@", deviceType);
    
    NSRange range = [deviceType rangeOfString:name];
    return range.location != NSNotFound;
}
-(void)close:(NSMutableArray *)inArguments {
	PluginLog(@"[EUExSensor close]");
	NSString *inType = [inArguments objectAtIndex:0];
	if (inType!=nil) {
		//int oType =[inType intValue];
		NSMutableDictionary *argsDict = [[NSMutableDictionary alloc]initWithCapacity:UEX_PLATFORM_CALL_ARGS];
		[argsDict setObject:inType forKey:@"F_SENSOR_CLOSE_TYPE"];
		switch ([inType intValue]) {
			 case F_SENSOR_TYPE_ACCELEROMETER: //操作
				[sensorObj closeAccelerSensor];
				break;
			case F_SENSOR_TYPE_ORIENTATION:
				//操作同加速度
				break;
			case F_SENSOR_TYPE_MAGNETIC_FIELD: //操作
				[sensorObj closeMagneticSensor];
				break;
			case F_SENSOR_TYPE_TEMPERATURE:
				//操作无api
				break;
			case F_SENSOR_TYPE_PRESSURE:
				//操作无api	
				break;
			case F_SENSOR_TYPE_LIGHT:
				//操作无api
				break;
			default:
				break;
		}
		[argsDict release];
	}
}

-(void)uexSensorWithType:(int)inType sensorX:(float)inSensorX sensorY:(float)inSensorY sensorZ:(float)inSensorZ {
	//NSString *jsStr = nil;
	switch (inType) {
		case F_SENSOR_TYPE_ACCELEROMETER:
			//jsStr = [NSString stringWithFormat:@"if(uexSensor.onAccelerometerChange !=null){uexSensor.onAccelerometerChange(%f,%f,%f)}",inSensorX,inSensorY,inSensorZ];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSensor.onAccelerometerChange" arguments:ACArgsPack(@(inSensorX),@(inSensorY),@(inSensorZ))];
			break;
		case F_SENSOR_TYPE_MAGNETIC_FIELD:
			//jsStr = [NSString stringWithFormat:@"if(uexSensor.onMagneticChange !=null){uexSensor.onMagneticChange(%f,%f,%f)}",inSensorX,inSensorY,inSensorZ];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSensor.onMagneticChange" arguments:ACArgsPack(@(inSensorX),@(inSensorY),@(inSensorZ))];
			break;
		default:
			//[self jsFailedWithOpId:0 errorCode:1170108 errorDes:UEX_ERROR_DESCRIBE_DEVICE_SUPPORT];
			break;
	}
	//PluginLog(@"jsstr=%@",jsStr);
	//[meBrwView stringByEvaluatingJavaScriptFromString:jsStr];
    //[self.webViewEngine callbackWithFunctionKeyPath:@"" arguments:ACArgsPack(@(inSensorX),@(inSensorY),@(inSensorZ))];
}

-(void)clean{
	if (sensorObj) {
		[sensorObj closeAllSensor];
        [sensorObj release];
        sensorObj = nil;
	}
}

@end
