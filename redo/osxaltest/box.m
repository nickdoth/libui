// 31 july 2015
#import "osxaltest.h"

@interface tBox : NSObject<tControl> {
	NSMutableArray *children;
	NSView *sv;
	BOOL vertical;
}
@end

@implementation tBox

- (id)initVertical:(BOOL)vert
{
	self = [super init];
	if (self) {
		self->children = [NSMutableArray new];
		self->sv = nil;
		self->vertical = vert;
	}
	return self;
}

- (void)addControl:(NSObject<tControl> *)c stretchy:(BOOL)s
{
	// TODO
}

- (void)tAddToView:(NSView *)v
{
	self->sv = v;
	[self->children enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
		NSView *vv;

		vv = (NSView *) obj;
		[v addSubview:vv];
	}];
}

- (uintmax_t)tAddToAutoLayoutDictionary:(NSMutableDictionary *)views keyNumber:(uintmax_t)n
{
	[self->children enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
		NSObject<tControl> *c;

		c = (NSObject<tControl> *) obj;
		n = [c tAddToAutoLayoutDictionary:views keyNumber:n];
	}];
	return n;
}

- (NSString *)tBuildAutoLayoutConstraintsKeyNumber:(uintmax_t)n
{
	NSMutableString *constraints;

	if (self->vertical)
		constraints = [NSMutableString stringWithString:@"V:"];
	else
		constraints = [NSMutableString stringWithString:@"H:"];
	[constraints appendString:@"|"];
	[self->children enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
		NSString *thisView;

		// TODO have every control do this
		[constraints appendString:tAutoLayoutKey(n)];
		n++;
	}];
	[constraints appendString:@"|"];
	return constraints;
}

@end
