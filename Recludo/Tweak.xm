@interface SBAwayLockBar

-(void)unlock;

@end

@interface SBAwayView

-(BOOL)isShowingMediaControls;

@end

@interface SBAwayController : NSObject {
	SBAwayView *_awayView;
}

+(id)sharedAwayController;

@end

@interface SBApplication 

-(id)applicationWithDisplayIdentifier:(id)arg1;

@end

@interface SBApplicationController

+(id)sharedInstance;

@end

@interface SBUIController

+(id)sharedInstance;
-(void)activateApplicationFromSwitcher:(SBApplication *)application;

@end

static BOOL recludo;

%hook SBAwayLockBar

-(void)unlock {
	id awayController = [objc_getClass("SBAwayController") sharedAwayController];
	void *out;
	Ivar awayViewVar = object_getInstanceVariable(awayController,"_awayView",&out);
	SBAwayView *awayView = object_getIvar(awayController,awayViewVar);
	if ([awayView isShowingMediaControls]) {
		recludo = YES;
	}
	%orig;
}

%end

%hook SBAwayController

- (void)_finishedUnlockAttemptWithStatus:(NSInteger)status {
	%orig;
	if (recludo && (status == 1)) {
		recludo = NO;
 		SBApplication *pendingApplication = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:@"com.apple.mobileipod"];
       	[[objc_getClass("SBUIController") sharedInstance] activateApplicationFromSwitcher:pendingApplication];
	}
}
%end