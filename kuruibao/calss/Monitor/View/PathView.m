//
//  PathView.m
//  CircleGradientLayer
//
//  Created by Dinotech on 16/1/6.
//  Copyright © 2016年 Dinotech. All rights reserved.
//

#import "PathView.h"

#import <QuartzCore/QuartzCore.h>
#define RYUIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface PathView ()

/**
 绘制的轨迹
 */
@property (strong, nonatomic) UIBezierPath *path_Joyce;

/**
 渐变层
 */
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) CAGradientLayer *gradientLayer1;
@property (strong, nonatomic) CALayer *gran;



@end


@implementation PathView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        self.animationTime = 1;
        self.beginColor = XMWhiteColor;
        self.endColor = XMGrayColor;
        [self gradentWith:frame];
    }
    return self;
}

- (void)gradentWith:(CGRect)frame{
    //设置贝塞尔曲线
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(frame.size.width-PROGRESS_LINE_WIDTH)/2-12 startAngle:M_PI * 3 / 2 endAngle:M_PI* 3 / 2 clockwise:YES];
    //遮罩层
    
    _progressLayer = [CAShapeLayer layer];

    _progressLayer.frame = self.bounds;
    
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    
    _progressLayer.strokeColor=[UIColor redColor].CGColor;
    
    _progressLayer.lineCap = kCALineCapButt;
    
    _progressLayer.lineWidth = PROGRESS_LINE_WIDTH+13;
    

   
    //渐变图层
    CALayer * grain = [CALayer layer];
//
    _gradientLayer =  [CAGradientLayer layer];
    
    _gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width/3, self.bounds.size.height);
   
    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[_beginColor CGColor],(id)[_endColor CGColor], nil]];
    
//    [_gradientLayer setLocations:@[@0.1,@0.9]];
    
    [_gradientLayer setStartPoint:CGPointMake(0., 0)];

    [_gradientLayer setEndPoint:CGPointMake(0, 1)];
    
    //
    
    _gradientLayer1 =  [CAGradientLayer layer];
    
    _gradientLayer1.frame = CGRectMake( self.bounds.size.width/3,0, self.bounds.size.width/3*2, self.bounds.size.height);
    
    [_gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[_beginColor CGColor],(id)[_endColor CGColor], nil]];
    
    //    [_gradientLayer setLocations:@[@0.1,@0.9]];
    
    [_gradientLayer1 setStartPoint:CGPointMake(.0, 0)];
    
    [_gradientLayer1 setEndPoint:CGPointMake(0, 1)];

//    
    [grain addSublayer:_gradientLayer];
    [grain addSublayer:_gradientLayer1];
    
    [grain setMask:_progressLayer];
 
    [self.layer addSublayer:grain];
    
    self.path_Joyce = path;
    
    self.gran = grain;
    
    //增加动画
    
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];

    pathAnimation.duration = _animationTime;

    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];

    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];

    pathAnimation.autoreverses=NO;
 
    _progressLayer.path= path.CGPath;
    
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    


}


-(void)animateWithDuration:(float)animationTime percent:(float)percent
{
    
//    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[_beginColor CGColor],(id)[_endColor CGColor], nil]];
//    [_gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[_beginColor CGColor],(id)[_endColor CGColor], nil]];

    
    _path_Joyce = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(self.bounds.size.width-PROGRESS_LINE_WIDTH)/2-12 startAngle:M_PI * 3 / 2 endAngle:M_PI* (3+4*percent) / 2  clockwise:YES];
    
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    pathAnimation.duration = animationTime;
    
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    
    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
    
    pathAnimation.autoreverses=NO;
 
    _progressLayer.path=_path_Joyce.CGPath;
    
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

}


- (void)keyui{
     UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, 150) radius:(PROGRESS_WIDTH+50) startAngle:degressToRadius(135) endAngle:degressToRadius(45) clockwise:YES];
    
    
    CAShapeLayer * angleline = [CAShapeLayer layer];
    angleline.frame = self.bounds;
    angleline.lineCap = kCALineCapSquare;
    angleline.lineWidth = 14.0f;
    angleline.path = path.CGPath;
    angleline.fillColor = [UIColor clearColor].CGColor;
//    angleline.strokeColor = [UIColor redColor].CGColor;
    
    CAKeyframeAnimation * keyanimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    keyanimation.values = @[(id)[[UIColor blueColor] CGColor],
                              (id)[[UIColor colorWithRed:0.9 green:0.0 blue:0.9 alpha:1.0] CGColor],
                              (id)[[UIColor redColor] CGColor],(id)[[UIColor blueColor] CGColor]];
    keyanimation.duration = 3.0f;
    keyanimation.repeatCount = INFINITY;
    keyanimation.removedOnCompletion = YES;
    keyanimation.fillMode = kCAFillModeForwards;
    
    keyanimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [angleline addAnimation:keyanimation forKey:@"animation"];
    
    
    
    [self.layer addSublayer:angleline];
    
    
    
    [path stroke];
    
}

- (void)setup{
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, 150) radius:(PROGRESS_WIDTH+50) startAngle:degressToRadius(135) endAngle:degressToRadius(45) clockwise:YES];
//    UIBezierPath * path = [UIBezierPath bezierPathWithRect:(CGRect){50,50,100,100}];
//     UIBezierPath * path = [UIBezierPath bezierPath];
//    [path moveToPoint:(CGPoint){30,30}];
//    [path addLineToPoint:(CGPoint){100,30}];
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = PROGRESS_LINE_WIDTH+10;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 1;
    _progressLayer.opacity = 1.0f;
//    [self.layer addSublayer:_progressLayer];
    
    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame =CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

    [gradientLayer1 setColors:[NSArray arrayWithObjects:(__bridge  id)[[UIColor redColor] CGColor],(__bridge id)[[UIColor yellowColor] CGColor],(__bridge id)[[UIColor purpleColor] CGColor], nil]];
    [gradientLayer1 setLocations:@[@(0.15),@(0.7)]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 0)];
    [gradientLayer addSublayer:gradientLayer1];
    gradientLayer1.backgroundColor = [UIColor whiteColor].CGColor;
//
//    [self.layer addSublayer:gradientLayer];
    
//    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
//    [gradientLayer2 setLocations:@[@0.5,@1]];
//    gradientLayer2.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
//    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor yellowColor] CGColor],(id)[[UIColor blueColor] CGColor], nil]];
//    [gradientLayer2 setStartPoint:CGPointMake(0, 0)];
//    [gradientLayer2 setEndPoint:CGPointMake(1, 0)];
//    [gradientLayer addSublayer:gradientLayer2];

    
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
     [path stroke];
}
- (void)initUI{
//    UIColor *color = [UIColor redColor];
//    [color setStroke]; //设置线条颜色
    //创建一个轨迹形状
    _trackLayer = [CAShapeLayer layer];
    _trackLayer.frame = self.frame;
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = [UIColor clearColor].CGColor;
    //指定画笔颜色
    _trackLayer.strokeColor = [UIColor redColor].CGColor;
    //设置透明度
    _trackLayer.opacity =1;
    _trackLayer.lineCap = kCALineCapRound;
    _trackLayer.lineWidth = PROGRESS_LINE_WIDTH;
    
UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 150) radius:(PROGRESS_WIDTH-PROGRESS_LINE_WIDTH)/2 startAngle:degressToRadius(135) endAngle:degressToRadius(45) clockwise:YES];
//        self.backgroundColor = [UIColor redColor];
//        path.lineWidth = 5.0;
    // 把path 传递给layer 然后layer会处理相应的渲染，
    _trackLayer.path = path.CGPath;
//        path.lineCapStyle = kCGLineCapRound;
//        path.lineJoinStyle = kCGLineCapRound;
    
    
        [path stroke];
    
}

//- (void)drawRect:(CGRect)rect
//{
//    UIColor *color = [UIColor redColor];
//    [color set]; //设置线条颜色
    // 1
//    UIBezierPath * path = [UIBezierPath bezierPathWithRect:(CGRect){100,50,50,50}];
//    self.backgroundColor = [UIColor redColor];
//    path.lineWidth = 5.0;
//    path.lineCapStyle = kCGLineCapRound;
//    path.lineJoinStyle = kCGLineCapRound;
//    
//    
//    [path stroke];
////    [path closePath];
   
    // 2
//    UIBezierPath* aPath = [UIBezierPath bezierPath];
//    aPath.lineWidth = 5.0;
//    
//    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
//    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
//    
//    // Set the starting point of the shape.
//    [aPath moveToPoint:CGPointMake(100.0, 0.0)];
//    
//    // Draw the lines
//    [aPath addLineToPoint:CGPointMake(200.0, 40.0)];
//    [aPath addLineToPoint:CGPointMake(160, 140)];
//    [aPath addLineToPoint:CGPointMake(40.0, 140)];
//    [aPath addLineToPoint:CGPointMake(0.0, 40.0)];
//    [aPath closePath];//第五条线通过调用closePath方法得到的
//    
//    [aPath stroke];//Draws line 根据坐标点连线
    // 3  画椭圆或者圆形
//    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:(CGRect){0,self.bounds.size.height/3,self.bounds.size.width,self.bounds.size.height/2}];
//    path.lineWidth = 2.0;
//    path.lineCapStyle = kCGLineCapRound;
//    path.lineJoinStyle = kCGLineCapRound;
//    [path stroke];
    
    //4 带有圆弧的矩形
    /*
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){5,self.bounds.size.height/3,self.bounds.size.width-10,self.bounds.size.height/2} cornerRadius:50.0f];
    path.lineWidth = 2.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    [path stroke];
    */
    
    /*
     画一段圆弧
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:50 startAngle:degressToRadius(150) endAngle:degressToRadius(40) clockwise:YES];
    path.lineWidth = 2.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    [path stroke];
*/
    //绘制一次曲线
    /*
     UIBezierPath * path = [UIBezierPath bezierPath];
     path.lineWidth = 2.0;
     path.lineCapStyle = kCGLineCapRound;
     path.lineJoinStyle = kCGLineCapRound;
     [path moveToPoint:CGPointMake(30, 50)];
     [path addQuadCurveToPoint:(CGPoint){150,50} controlPoint:(CGPoint){90,10}];
     
     [path stroke];
     */
    //h绘制二次贝塞尔曲线
    /*
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 2.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    [path moveToPoint:CGPointMake(20, 50)];
    [path addCurveToPoint:(CGPoint){160,50} controlPoint1:(CGPoint){60,2} controlPoint2:(CGPoint){90,100}];
    
    [path stroke];
    */
   /*
    //UIBezierPath  利用path的CGPATH属性结合起来使用
    UIBezierPath * path = [UIBezierPath bezierPath];
//    path.CGPath = cgpah;
    CGPathRef cgpath = path.CGPath;
    // 根据奇偶规则进行绘制
    path.usesEvenOddFillRule  = YES;
    CGMutablePathRef  cgpah = CGPathCreateMutableCopy(cgpath);
    CGPathAddEllipseInRect(cgpah, NULL, (CGRect){10 ,10,50,50});
    CGPathAddEllipseInRect(cgpah, NULL, (CGRect){50 ,50,100,100});
    path.CGPath = cgpah;
    [path stroke];
    
    CGPathRelease(cgpah);
    */
    //rendering  渲染机制，我们设置好路径提供画布画图
    /*
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:(CGRect){0,0,100,100}];
    [[UIColor blueColor] setStroke];
    [[UIColor redColor] setFill];
    //得到当前画布上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //如果画布有改变，加上队上下文的保存
    CGContextSaveGState(ref);
    CGContextTranslateCTM(ref, 50, 10);
    path.lineWidth = 4.0f;
    [path fill];
    [path stroke];
    CGContextRestoreGState(ref);
     */
    //指定其中一个角进行圆角化
//    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){20,10,100,100} byRoundingCorners:UIRectCornerTopRight cornerRadii:(CGSize){20,10}];
//    path.lineWidth = 3.0f;
//    
//    [path stroke];

//}
- (UIImage*) BgImageFromColors:(NSArray*)colors withFrame: (CGRect)frame

{
    
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        
        [ar addObject:(id)c.CGColor];
        
    }
    
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    
    CGPoint start;
    
    CGPoint end;
    
    
    
    start = CGPointMake(0.0, frame.size.height);
    
    end = CGPointMake(frame.size.width, 0.0);
    
    
    
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
    
//    CGColorSpaceRelease(colorSpace);
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
//    CGRect pathRect = CGPathGetBoundingBox(path);
//    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGPoint center = CGPointMake(60, 60);

    CGFloat radius = 300;// MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    

    [self.gran setMask:_progressLayer];
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


- (void)drawRect:(CGRect)rect
{
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    [self drawRadialGradient:ctx path:_path_Joyce.CGPath startColor:XMWhiteColor.CGColor endColor:XMGrayColor.CGColor];

//    [_progressLayer.accessibilityPath addClip];

}



@end
