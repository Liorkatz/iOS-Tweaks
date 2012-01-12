#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

static BOOL giaFatto=NO;

@interface UnAlarm : NSObject <UIAlertViewDelegate> 
{

	NSString *plistPath;
	NSString *fullyPath;
	NSString *title;
	NSString *message;
	NSString *alarmPath;
	NSString *titleF;
	NSString *messageF;
	BOOL fullyEnabled;
	BOOL fullySound;
	BOOL notificationEnabled;
	BOOL tweakEnabled;
	BOOL fakeTextEnabled;
	BOOL fakeTitleEnabled;
	BOOL connectedEnabled;
	AVAudioPlayer *audioPlayer;

}

- (void)showAlert;
- (void)uaConnected;
- (void)fullyAlert;

@end

@implementation UnAlarm

-(id)init
{
	//Set variabiles for uaalert
	plistPath = [NSString stringWithString:@"/var/mobile/Library/Preferences/com.istopped.unalarm.plist"];
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
	tweakEnabled = [[dict objectForKey:@"UAEnabled"] boolValue];
	notificationEnabled = [[dict objectForKey:@"UANotification"] boolValue];
	fakeTextEnabled = [[dict objectForKey:@"UAUseFakeText"] boolValue];
	fakeTitleEnabled = [[dict objectForKey:@"UAUseFakeTitle"] boolValue];
	connectedEnabled = [[dict objectForKey:@"UAConnected"] boolValue];
	fullyEnabled = [[dict objectForKey:@"UAFully"] boolValue];
	fullySound = [[dict objectForKey:@"UAFullySound"] boolValue];
	alarmPath = [NSString stringWithString:@"/var/mobile/Library/UnAlarm/alarm_sound.caf"];
	fullyPath = [NSString stringWithString:@"/var/mobile/Library/UnAlarm/fully_sound.caf"];
	if (fakeTitleEnabled) {
		title = [dict objectForKey:@"UAFakeTitle"];
	}
	else {
		title = [NSString stringWithString:@"Attention!"];
	}
	if (fakeTextEnabled) {
		message = [dict objectForKey:@"UAFakeText"];
	}
	else {
		message = [NSString stringWithString:@"The device has been disconnected from the power source."];
	}
	return self;
}


-(void)showAlert
{
	if (tweakEnabled) {
		NSURL *url = [NSURL fileURLWithPath:[NSString stringWithString:alarmPath]];
		audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		//audioPlayer.numberOfLoops = 1;
		[audioPlayer play];
  		if (notificationEnabled) {
			UIAlertView *uaAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
			[uaAlert show];
			[uaAlert release];
  		}
  	}
}

- (void)uaConnected 
{
	if (tweakEnabled) {
		if (connectedEnabled) {
			float batteryLevelLocal = [UIDevice currentDevice].batteryLevel;
			batteryLevelLocal = batteryLevelLocal * 100;
			NSString *messageConn = [NSString stringWithFormat:@"You now have %0.f %% left. \n You will be notified when the battery is fully charged.", batteryLevelLocal];
			UIAlertView *connectedView = [[UIAlertView alloc] initWithTitle:@"Charging" message:messageConn delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
			[connectedView show];
			[connectedView release];
		}
	}
}

- (void)fullyAlert
{
	if (tweakEnabled) {
		if (fullyEnabled) {
			if (fullySound) {
				NSURL *url = [NSURL fileURLWithPath:[NSString stringWithString:fullyPath]];
				audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
				[audioPlayer play];
			}
			UIAlertView *fully = [[UIAlertView alloc] initWithTitle:@"Fully charged" message:@"Your device is fully charged" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
			[fully show];
			[fully release];
		}
	}
}	

-(void)dealloc {
	[super dealloc];
	[audioPlayer stop];
	[audioPlayer release];
}

@end


%hook SBUIController

-(void)ACPowerChanged
{ 
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
	if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged) {
		UnAlarm *ua = [[UnAlarm alloc] init];
		[ua showAlert];
		giaFatto = NO;
	}
	if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {
		UnAlarm *ua = [[UnAlarm alloc] init];
		[ua uaConnected];
		giaFatto = NO;
	}
  	%orig;
}

%end

%hook	SBStatusBarDataManager

- (void)_updateBatteryPercentItem 
{
	float batteryLevelLocal = [UIDevice currentDevice].batteryLevel;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
	if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateFull) {
		if ((batteryLevelLocal == 1.0) && (!giaFatto)) {
			UnAlarm *ua = [[UnAlarm alloc] init];
			[ua fullyAlert];
			giaFatto = YES;
		}
	}
	%orig;
}

%end