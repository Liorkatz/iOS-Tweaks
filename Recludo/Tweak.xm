#import <SpringBoard/SBApplication.h>

BOOL controls;

%hook SBAwayView
- (void)hideMediaControls {
	controls = NO;
	%orig;
}
- (void)_hideMediaControls {
	controls = NO;
	%orig;
}
- (void)showMediaControls {
	controls = YES;
	%orig;
}
%end

%hook SBAwayController
- (void)_finishedUnlockAttemptWithStatus:(NSInteger)status {
	%orig;
	if (controls && (status == 1)) {
		SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:@"com.apple.mobileipod"];
		[[%c(SBUIController) sharedInstance] activateApplicationFromSwitcher:app];
	}
}
%end