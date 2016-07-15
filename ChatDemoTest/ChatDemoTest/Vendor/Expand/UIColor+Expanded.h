// Erica Sadun 

// Thanks to Poltras, Millenomi, Eridius, Nownot, WhatAHam, jberry,
// and everyone else who helped out but whose name is inadvertantly omitted

/*
 BSD License.
 
 This work 'as-is' I provide.
 No warranty express or implied.
 I've done my best,
 to debug and test.
 Liability for damages denied.
 */

/*
 Current outstanding request list: (NONE)
 
 Requests recently added:
 Layton at PolarBearFarm - color descriptions 
    e.g. ([UIColor warmGrayWithHintOfBlueTouchOfRedAndSplashOfYellowColor])
 Added: Auto color descriptions, especially using xkcd 
 
 Kevin / Eridius 
 UIColor needs a method that takes 2 colors and gives a third complementary one
 new kevinColorWithColor: method

 Adjustable colors: brighter, cooler, warmer, etc.
 Added: Various tweakers, warmth property, temperature stuff 
 */

/*
 
 Update checklist:
 
 UInt32 -> uint32_t
 float -> CGFloat
 int -> NSInteger except w/ simple for loops
 fmax, fmin -> cgfmax, cgfmin
 unit clamping -> cgfunitclamp
 
 */


#import <UIKit/UIKit.h>


// Color Space
extern CGColorSpaceRef DeviceRGBSpace();
extern CGColorSpaceRef DeviceGraySpace();

extern UIColor *RandomColor();
extern UIColor *InterpolateColors(UIColor *c1, UIColor *c2, CGFloat percent);

@interface UIColor (UIColor_Expanded)

#pragma mark - Color Wheel
+ (UIImage *) colorWheelOfSize: (CGFloat) side border:(BOOL) yorn;

#pragma mark - Color Space
+ (NSString *) colorSpaceString: (CGColorSpaceModel) model;
@property (nonatomic, readonly) NSString *colorSpaceString;
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) BOOL usesMonochromeColorspace;
@property (nonatomic, readonly) BOOL usesRGBColorspace;

#pragma mark - Color Conversion
+ (void) hue:(CGFloat)h saturation:(CGFloat)s brightness:(CGFloat)v toRed:(CGFloat *)pR green:(CGFloat *)pG blue:(CGFloat *)pB;
+ (void) red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b toHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV;
extern void RGB2YUV_f(CGFloat r, CGFloat g, CGFloat b, CGFloat *y, CGFloat *u, CGFloat *v);
extern void YUV2RGB_f(CGFloat y, CGFloat u, CGFloat v, CGFloat *r, CGFloat *g, CGFloat *b);

//  public domain functions by Darel Rex Finley, 2006
extern void RGBtoHSP(CGFloat  R, CGFloat  G, CGFloat  B, CGFloat *H, CGFloat *S, CGFloat *P);
extern void HSPtoRGB(CGFloat  H, CGFloat  S, CGFloat  P, CGFloat *R, CGFloat *G, CGFloat *B);
@property (nonatomic, readonly) CGFloat perceivedBrightness;

#pragma mark - Color Components
// With the exception of -alpha, these properties will function
// correctly only if this color is an RGB or white color.
// In these cases, canProvideRGBComponents returns YES.
@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;

@property (nonatomic, readonly) CGFloat premultipliedRed;
@property (nonatomic, readonly) CGFloat premultipliedGreen;
@property (nonatomic, readonly) CGFloat premultipliedBlue;

+ (UIColor *) colorWithCyan: (CGFloat) c magenta: (CGFloat) m yellow: (CGFloat) y black: (CGFloat) k;
- (void) toC: (CGFloat *) cyan toM: (CGFloat *) magenta toY: (CGFloat *) yellow toK: (CGFloat *) black;
@property (nonatomic, readonly) CGFloat cyanChannel;
@property (nonatomic, readonly) CGFloat magentaChannel;
@property (nonatomic, readonly) CGFloat yellowChannel;
@property (nonatomic, readonly) CGFloat blackChannel;
@property (nonatomic, readonly) NSArray *cmyk;

@property (nonatomic, readonly) Byte redByte;
@property (nonatomic, readonly) Byte greenByte;
@property (nonatomic, readonly) Byte blueByte;
@property (nonatomic, readonly) Byte alphaByte;
@property (nonatomic, readonly) Byte whiteByte;
@property (nonatomic, readonly) NSData *colorBytes;
@property (nonatomic, readonly) NSData *premultipledColorBytes;

@property (nonatomic, readonly) CGFloat white;
@property (nonatomic, readonly) CGFloat luminance; // 0 ~ 1

@property (nonatomic, readonly) CGFloat hue;
@property (nonatomic, readonly) CGFloat saturation;
@property (nonatomic, readonly) CGFloat brightness;

@property (nonatomic, readonly) CGFloat alpha;

@property (nonatomic, readonly) uint32_t rgbHex;

// @[@(r), @(g), @(b), @(a)]
- (NSArray *)arrayFromRGBAComponents;

// Return a grey-scale representation of the color
- (UIColor *) colorByLuminanceMapping;

#pragma mark - Alternative Expression
// Grays return 0. Fully saturated return 1
@property (nonatomic, readonly) CGFloat colorfulness;
// Ranges from 0..1, cold (BLUE) to hot (YELLOW)
@property (nonatomic, readonly) CGFloat warmth;

#pragma mark - Building
// Build colors by comparison
- (UIColor *) adjustWarmth: (CGFloat) delta;
- (UIColor *) adjustBrightness: (CGFloat) delta;
- (UIColor *) adjustSaturation: (CGFloat) delta;
- (UIColor *) adjustHue: (CGFloat) delta;

#pragma mark - Sorting
// Sorting -- Natural sorting choices
- (NSComparisonResult) compareWarmth: (UIColor *) anotherColor;
- (NSComparisonResult) compareColorfulness: (UIColor *) anotherColor;
- (NSComparisonResult) compareHue: (UIColor *) anotherColor;
- (NSComparisonResult) compareSaturation: (UIColor *) anotherColor;
- (NSComparisonResult) compareBrightness: (UIColor *) anotherColor;

#pragma mark - Distance
// Color Distance
// return 0 ~ 1
- (CGFloat) luminanceDistanceFrom: (UIColor *) anotherColor;
// return 0 ~ √3
- (CGFloat) distanceFrom: (UIColor *) anotherColor;
- (BOOL) isEqualToColor: (UIColor *) anotherColor;

#pragma mark - Math
// Arithmetic operations on the color
- (UIColor *) colorByMultiplyingByRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha;
- (UIColor *)        colorByAddingRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha;
- (UIColor *)  colorByLighteningToRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha;
- (UIColor *)   colorByDarkeningToRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha;

- (UIColor *) colorByMultiplyingBy: (CGFloat) f;
- (UIColor *)        colorByAdding: (CGFloat) f;
- (UIColor *)  colorByLighteningTo: (CGFloat) f;
- (UIColor *)   colorByDarkeningTo: (CGFloat) f;

- (UIColor *) colorByMultiplyingByColor: (UIColor *) color;
- (UIColor *)        colorByAddingColor: (UIColor *) color;
- (UIColor *)  colorByLighteningToColor: (UIColor *) color;
- (UIColor *)   colorByDarkeningToColor: (UIColor *) color;

- (UIColor *)colorByInterpolatingToColor:(UIColor *)color byFraction:(CGFloat)fraction;

- (UIColor *) colorWithBrightness: (CGFloat) brightness;
- (UIColor *) colorWithSaturation: (CGFloat) saturation;
- (UIColor *) colorWithHue: (CGFloat) hue;

// Related colors
- (UIColor *) contrastingColor;            // A good contrasting color: will be either black or white
- (UIColor *) complementaryColor;        // A complementary color that should look good with this color
- (NSArray *) triadicColors;                // Two colors that should look good with this color
- (NSArray *) analogousColorsWithStepAngle: (CGFloat) stepAngle pairCount: (NSInteger) pairs;    // Multiple pairs of colors

- (UIColor *) kevinColorWithColor: (UIColor *) secondColor; // see Eridius request

#pragma mark - Strings
// String support
@property (nonatomic, readonly) NSString *stringValue;
@property (nonatomic, readonly) NSString *hexStringValue;
@property (nonatomic, readonly) NSString *valueString;
// {r, g, b, a} --> {0.3, 1, 0.5, 1}
+ (UIColor *) colorWithString: (NSString *) string;
// "0x65ce00" or "#0x65ce00"
+ (UIColor *) colorWithRGBHexString: (NSString *)stringToConvert;
+ (UIColor *) colorWithRGBHex: (uint32_t)hex;

// "0xff65ce00" or "#0xff65ce00"
+ (UIColor *) colorWithARGBHexString: (NSString *)stringToConvert;
+ (UIColor *) colorWithARGBHex: (uint32_t)hex;

#pragma mark - Temperature
// Temperature support -- preliminary
+ (UIColor *) colorWithKelvin: (CGFloat) kelvin;
+ (NSDictionary *) kelvinDictionary;
@property (nonatomic, readonly) CGFloat colorTemperature;

#pragma mark - Random
// Random Color
+ (UIColor *) randomColor;
+ (UIColor *) randomDarkColor : (CGFloat) scaleFactor;
+ (UIColor *) randomLightColor : (CGFloat) scaleFactor;
@end

@interface UIImage (UIColor_Expanded)
@property (nonatomic, readonly) CGColorSpaceRef colorSpace;
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) NSString *colorSpaceString;
@end
