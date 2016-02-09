//
//  Toggle.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Toggle.h"
#import "MenuButton.h"

@interface Toggle ()
@property (nonatomic, strong) NSString *imagePrefix;
@end

@implementation Toggle

- (id)initWithText:(NSString *)text anchor:(NSInteger)anchor option:(NSString *)option position:(CGPoint)pos font:(UIFont *)font imageName:(NSString *)imageName
{
	if ((self = [super initWithText:text anchor:anchor command:nil position:pos font:font imageName:imageName color:@"white" radius:-1])) {
		_imagePrefix = imageName;
		_option = option;
		[self updateImage];
	}
	return self;
}

- (void)updateImage
{
	BOOL on = [[NSUserDefaults standardUserDefaults] boolForKey:self.option];
	NSString *colorName = on ? @"orange" : @"white";
	NSString *imageName = [NSString stringWithFormat:@"%@_%@", _imagePrefix, colorName];

#if TARGET_OS_TV
	UIImage *image = [UIImage imageNamed:imageName];
	[self.button setImage:image forState:UIControlStateNormal];
#else
	[self setImageName:imageName];
#endif
}

- (void)buttonAction:(id)sender
{
	// Small animation to show click
	if ([sender isKindOfClass:[MenuButton class]]) {
		MenuButton *button = sender;
		[UIView animateWithDuration:0.1 animations:^{
			button.transform = CGAffineTransformMakeScale(button.focusScale*0.8, button.focusScale*0.8);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.1 animations:^{
				button.transform = CGAffineTransformMakeScale(button.focusScale, button.focusScale);
			} completion:NULL];
		}];
	}

	[self collisionAction];
}

- (void)collisionAction
{
	BOOL on = [[NSUserDefaults standardUserDefaults] boolForKey:self.option];
	BOOL newValue = !on;

	self.command = [NSString stringWithFormat:@"#%@ %d", self.option, newValue];
	[super collisionAction];

	[self updateImage];
}

@end
