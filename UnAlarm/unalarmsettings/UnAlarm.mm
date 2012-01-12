#import <Preferences/Preferences.h>

@interface UnAlarmListController: PSListController {
}

-(IBAction)donate:(id)sender;
-(IBAction)contact:(id)sender;
-(IBAction)visit:(id)sender;
-(IBAction)follow:(id)sender;
@end

@implementation UnAlarmListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"UnAlarm" target:self] retain];
	}
	return _specifiers;
}

-(IBAction)donate:(id)sender 
{
	NSString *stringURL = @"http://playerstopped.tumblr.com/donate";
	NSURL *url = [NSURL URLWithString:stringURL];
	[[UIApplication sharedApplication] openURL:url];
}

-(IBAction)contact:(id)sender 
{
	NSString *subject = [NSString stringWithString:@"Support: UnAlarm"];
	NSString *address = [NSString stringWithString:@"playerstopped94@gmail.com"];
	NSString *path = [NSString stringWithFormat:@"mailto:%@?subject=%@", address, subject];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[[UIApplication sharedApplication] openURL:url];
}

-(IBAction)visit:(id)sender {
	NSString *site = [NSString stringWithString:@"http://playerstopped.tumblr.com/"];
	NSURL *url = [NSURL URLWithString:[site stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[[UIApplication sharedApplication] openURL:url];
}

-(IBAction)follow:(id)sender {
	NSString *twitter = [NSString stringWithString:@"http://twitter.com/#!/iStopped"];
	NSURL *url = [NSURL URLWithString:[twitter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[[UIApplication sharedApplication] openURL:url];
}

@end