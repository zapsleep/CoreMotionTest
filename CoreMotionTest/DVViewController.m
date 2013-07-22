//
//  DVViewController.m
//  CoreMotionTest
//
//  Created by Mikhail Grushin on 22.07.13.
//  Copyright (c) 2013 DENIVIP Group. All rights reserved.
//

#import "DVViewController.h"
#import <CoreMotion/CoreMotion.h>

#define kCMDeviceMotionUpdateFrequency (1.f/30.f)

@interface DVViewController ()
@property (weak, nonatomic) IBOutlet UILabel *accelerationXVal;
@property (weak, nonatomic) IBOutlet UILabel *accelerationYVal;
@property (weak, nonatomic) IBOutlet UILabel *accelerationZVal;

@property (weak, nonatomic) IBOutlet UILabel *gravityXVal;
@property (weak, nonatomic) IBOutlet UILabel *gravityYVal;
@property (weak, nonatomic) IBOutlet UILabel *gravityZVal;

@property (weak, nonatomic) IBOutlet UILabel *rotationXVal;
@property (weak, nonatomic) IBOutlet UILabel *rotationYVal;
@property (weak, nonatomic) IBOutlet UILabel *rotationZVal;

@property (weak, nonatomic) IBOutlet UILabel *pitch;
@property (weak, nonatomic) IBOutlet UILabel *roll;
@property (weak, nonatomic) IBOutlet UILabel *yaw;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation DVViewController

-(CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = kCMDeviceMotionUpdateFrequency;
        _motionManager.accelerometerUpdateInterval = kCMDeviceMotionUpdateFrequency;
        _motionManager.gyroUpdateInterval = kCMDeviceMotionUpdateFrequency;
    }
    
    return _motionManager;
}

-(CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMotionData)];
    }
    
    return _displayLink;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.motionManager startDeviceMotionUpdates];
    [self.motionManager startAccelerometerUpdates];
    [self.motionManager startGyroUpdates];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMotionData {
    CMAcceleration acceleration = self.motionManager.deviceMotion.userAcceleration;
    self.accelerationXVal.text = [NSString stringWithFormat:@"%.3f", acceleration.x];
    self.accelerationYVal.text = [NSString stringWithFormat:@"%.3f", acceleration.y];
    self.accelerationZVal.text = [NSString stringWithFormat:@"%.3f", acceleration.z];
    
    CMAcceleration gravity = self.motionManager.deviceMotion.gravity;
    self.gravityXVal.text = [NSString stringWithFormat:@"%.3f", gravity.x];
    self.gravityYVal.text = [NSString stringWithFormat:@"%.3f", gravity.y];
    self.gravityZVal.text = [NSString stringWithFormat:@"%.3f", gravity.z];
    
    CMRotationRate rotation = self.motionManager.gyroData.rotationRate;
    self.rotationXVal.text = [NSString stringWithFormat:@"%.3f", rotation.x];
    self.rotationYVal.text = [NSString stringWithFormat:@"%.3f", rotation.y];
    self.rotationZVal.text = [NSString stringWithFormat:@"%.3f", rotation.z];
    
    CMAttitude *attitude = self.motionManager.deviceMotion.attitude;
    self.pitch.text = [NSString stringWithFormat:@"%.3f", attitude.pitch];
    self.roll.text = [NSString stringWithFormat:@"%.3f", attitude.roll];
    CMQuaternion quaternion = attitude.quaternion;
    double yaw = asin(2*(quaternion.x*quaternion.z - quaternion.w*quaternion.y));
    self.yaw.text = [NSString stringWithFormat:@"%.3f", yaw];
}

@end
