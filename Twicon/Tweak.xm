#import <UIKit/UIWindow2.h>
#import <Twitter/Twitter.h>

@interface SBApplicationIcon : NSObject { }

- (id)generateIconImage:(int)arg1;
- (id)getStandardIconImageForLocation:(int)location;
- (id)getIconImage:(int)image;
- (id)getGenericIconImage:(int)image;
- (id)displayName;
- (void)launch;

@end

@interface SpringBoard : UIApplication 
{
}

- (int)activeInterfaceOrientation;

@end

@interface UIViewController (iOS5)

@property (nonatomic, readwrite, assign) int interfaceOrientation;

@end

@interface EmptyViewController : UIViewController
// Thanks Ryan :)
@end

@implementation EmptyViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown)
		|| ([UIDevice instancesRespondToSelector:@selector(userInterfaceIdiom)] && ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad));
}

@end

static NSString *getsuffix() { //Stolen! Thanks to Zimm :)
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
		return @"-72";
	
	if ([[UIScreen mainScreen] scale] < 2.0f)
		return @"";
	
	return @"@2x";
	
}

%subclass Twicon : SBApplicationIcon

static TWTweetComposeViewController *tweetComposer;
static UIWindow *tweetWindow;
static UIWindow *tweetFormerKeyWindow;

-(id)displayName
{		
	return @"Twicon";
}

- (void)launch
{
	if (tweetComposer) {
		[tweetWindow.firstResponder resignFirstResponder];
		[tweetFormerKeyWindow makeKeyWindow];
		[tweetFormerKeyWindow release];
		tweetFormerKeyWindow = nil;
		[self performSelector:@selector(hideTweetWindow) withObject:nil afterDelay:0.5];
		[tweetWindow.rootViewController dismissModalViewControllerAnimated:YES];
		[tweetComposer release];
		tweetComposer = nil;
	} else {
		tweetComposer = [[TWTweetComposeViewController alloc] init];
		if (!tweetComposer) {
			return;
		}
		if (tweetWindow)
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTweetWindow) object:nil];
		else
			tweetWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
			tweetWindow.windowLevel = UIWindowLevelStatusBar;
			[tweetFormerKeyWindow release];
		tweetFormerKeyWindow = [[UIWindow keyWindow] retain];
		UIViewController *vc = [[EmptyViewController alloc] init];
		vc.interfaceOrientation = [(SpringBoard *)[UIApplication sharedApplication] activeInterfaceOrientation];
		tweetWindow.rootViewController = vc;
		tweetComposer.completionHandler = ^(int result) {
			[tweetWindow.firstResponder resignFirstResponder];
			[tweetFormerKeyWindow makeKeyWindow];
			[tweetFormerKeyWindow release];
			tweetFormerKeyWindow = nil;
			[self performSelector:@selector(hideTweetWindow) withObject:nil afterDelay:0.5];
			[vc dismissModalViewControllerAnimated:YES];
			[tweetComposer release];
			tweetComposer = nil;
		};
		[tweetWindow makeKeyAndVisible];
		[vc presentModalViewController:tweetComposer animated:YES];
		[vc release];
	}
}

-(id)generateIconImage:(int)image
{
	return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Applications/Twicon.app/Twicon%@.png",getsuffix()]];
}

-(id)getStandardIconImageForLocation:(int)location
{
	return [self generateIconImage:location];
}

-(id)getIconImage:(int)image
{
	return [self generateIconImage:image];
}

-(id)getGenericIconImage:(int)image
{
	return [self generateIconImage:image];
}

%new(v:)
- (void)hideTweetWindow
{
	tweetWindow.hidden = YES;
	[tweetWindow release];
	tweetWindow = nil;
}

%end