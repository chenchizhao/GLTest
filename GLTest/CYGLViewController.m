//
//  CYGLViewController.m
//  GLTest
//
//  Created by RRTY on 17/1/11.
//  Copyright © 2017年 chenyan. All rights reserved.
//

#import "CYGLViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>

typedef struct {
    GLfloat Position[3]; // 坐标：x, y, z
    GLfloat Normal[3];//法线(用于开启光源)
    GLfloat Color[4]; // 颜色
    GLfloat texture[2];//纹理坐标  笛卡尔坐标系  与iPhone屏幕坐标系不同
} Vertex;


const Vertex Vertices[] = { //顶点坐标及颜色
    
    //正方体
    {{ 1, -1,  1}, { 0, 1,  0},    {1, 0, 0, 1}, {1,0} },//右下
    {{ 1,  1,  1}, { 0, 1,  0},    {0, 1, 0, 1}, {1,1} },//右上
    {{-1,  1,  1}, { 0, 1,  0},    {0, 0, 1, 1}, {0,1}},//左上
    {{-1, -1,  1}, { 0, 1,  0},    {1, 1, 0, 1}, {0,0}},//左下
    {{ 1, -1, -1}, { 0, 1,  0},    {0, 0, 1, 1}, {1,0}},
    {{ 1,  1, -1}, { 0, 1,  0},    {1, 1, 0, 1}, {1,1}},
    {{-1,  1, -1}, { 0, 1,  0},    {1, 0, 0, 1}, {0,1}},
    {{-1, -1, -1}, { 0, 1,  0},    {0, 1, 0, 1}, {0,0}},
    
    //底座
    {{ 1.5, -1.2,  1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1}},
    {{-1.5, -1.2,  1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1}},
    {{-1.5, -1.2, -1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1}},
    {{ 1.5, -1.2, -1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1}},
    
    {{ 1.5, -1.5,  1.5},{ 0, 1,  0},      {0.6, 0.6, 0.6, 1}},
    {{-1.5, -1.5,  1.5},{ 0, 1,  0},      {0.6, 0.6, 0.6, 1}},
    {{-1.5, -1.5, -1.5},{ 0, 1,  0},      {0.6, 0.6, 0.6, 1}},
    {{ 1.5, -1.5, -1.5},{ 0, 1,  0},      {0.6, 0.6, 0.6, 1}}
};

const GLubyte Indices[] = { // 数组元素值对应的是顶点在Vertices数组中的下标。
    //底座
    8,  9,  13,
    12, 13, 8,
    12, 15, 8,
    11, 15, 8,
    8,  9,  10,
    8,  11, 10,
    9,  10, 13,
    13, 14, 10,
//    12, 13, 15,
//    13, 15, 14,
    10, 14, 15,
    10, 11, 15,
    
    //正方体六个面
    0, 1, 2, // 每一个行对应组成三角形的3个顶点
    2, 3, 0,
    
    4, 5, 6,
    6, 7, 4,
    
    0, 1, 4,
    4, 5, 1,
    
    1, 5, 6,
    1, 2, 6,
    
    2, 3, 6,
    6, 7, 3,
    
    0, 3, 4,
    3, 4, 7,
    

    
};


@interface CYGLViewController () <GLKViewControllerDelegate,GLKViewDelegate>{
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    float _rotationX;
    float _rotationY;
    
    float _curR;
    float _curG;
    float _curB;
    BOOL _increasing;
}

@property (nonatomic,strong) EAGLContext* context;
@property (nonatomic,strong) GLKBaseEffect* effect;
@property (nonatomic,strong) GLKView* glkView;

@end

@implementation CYGLViewController

- (void)loadView {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    self.glkView = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.glkView.context = self.context;
    self.view = self.glkView;
    self.glkView.delegate = self;
    self.delegate = self;
//        self.glkView.enableSetNeedsDisplay = NO;
    
    //-------------------相关设置-----------------
    /*GLKViewController在1秒内会多次调用你的draw方法，设置调用的次数来让GLKViewController知道你期待被调用的频率。当然，如果你的游戏花了很多时间对帧进行渲染，实际的调用次数将你设置的值。
     缺省值是30FPS。苹果的指导意见是把这个值设置成你的app能够稳定支持的帧率，以保持一致，看起来不卡。这个app非常简单，可以按照60FPS运行，所以我们设置成60FPS。
     和FYI一样（FYI是神马啊？），如果你想知道OS实际尝试调用你的update/draw方法的次数，可以检查只读属性framesPerSecond。
     */
    self.preferredFramesPerSecond = 30;
    
    //颜色格式
    self.glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    //深度缓冲
    self.glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.glkView.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    
    //抗锯齿   以前对于每个像素，都会调用一次fragment shader（片段着色器），开启后会将像素区分成更小的单元，并在更细微的层面上多次调用fragment shader。之后它将返回的颜色合并，生成更光滑的几何边缘效果。(慎用，耗资源严重)
//    self.glkView.drawableMultisample = GLKViewDrawableMultisample4X;
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
    [self.view addGestureRecognizer:pan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"openGLTest";

    _increasing = YES;
    _curR = 1.0;
    _curG = 1.0;
    _curB = 1.0;
    

    [self setupGL];
    
    
}

- (void)dealloc {
    [self tearDownGL];
}
/**
 初始化
 */
- (void)setupGL {
    
    
    //1.设置的当前上下文（防止在实际操作中上下文切换带来的错误）
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_DEPTH_TEST);//发送第一个“GL”指令：激活“深度检测”。

    
    
    //------OpenGL的缓冲由一些标准的函数（glGenBuffers, glBindBuffer, glBufferData, glVertexAttribPointer）来创建、绑定、填充和配置；
    
    // 申请一个标识符Generate 1 buffer, put the resulting identifier in vertexbuffer
    glGenBuffers(1, &_vertexBuffer);
    // 把标识符绑定到GL_ARRAY_BUFFER上  The following commands will talk about our 'vertexbuffer' buffer
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    // 把顶点数据从cpu内存复制到gpu内存  Give our vertices to OpenGL.
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    //2.创建着色器
    self.effect = [[GLKBaseEffect alloc] init];
    //设置模型中的颜色缓存可用
//    self.effect.colorMaterialEnabled = GL_TRUE;
    
    
    //2.1创建光源并设置属性
    self.effect.light0.enabled = GL_TRUE;
    //光源位置向量
    self.effect.light0.position = GLKVector4Make(4, 4, 2, 0);
    //设置环境光线
    self.effect.light0.ambientColor = GLKVector4Make(0.2, 0.2, 0.2, 1);
    //漫反射光的颜色
    self.effect.light0.diffuseColor = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.f);
    //镜面高光
    self.effect.light0.specularColor = GLKVector4Make(1, 1, 1, 1);
    
    //2.2设置材料属性
    //材料反光度
    self.effect.material.shininess = 1;
    //材料发射光
//    self.effect.material.emissiveColor = GLKVector4Make(1, 0, 0, 1);
    
    //设置光源颜色
    self.effect.useConstantColor = GL_TRUE;
//    self.effect.constantColor = GLKVector4Make(0, 1, 1, 1);
    
    //3.纹理贴图
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"texture02.png" ofType:nil];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.name = textureInfo.name;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    

 


}

/**
 清除OpenGL缓存
 */
- (void)tearDownGL {
    
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = nil;
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    self.context = nil;
}

#pragma mark - touch
- (void)panEvent:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            CGPoint velocity = [gesture velocityInView:gesture.view];
            _rotationX += velocity.y / 100.0;
            _rotationY += velocity.x / 100.0;
            
//            if (_rotationX >= 90) {
//                _rotationX = 90;
//            }
//            if (_rotationX <= 0) {
//                _rotationX = 0;
//            }
            
            NSLog(@"rotaX:%f \n rotaY:%f",_rotationX,_rotationY);
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateEnded:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - glkViewControllerDelegate
- (void)glkViewControllerUpdate:(GLKViewController *)controller {
    
//    if (_increasing) {
//        _curRed += 1.0 * controller.timeSinceLastUpdate;
//    } else {
//        _curRed -= 1.0 * controller.timeSinceLastUpdate;
//    }
//    if (_curRed >= 1.0) {
//        _curRed = 1.0;
//        _increasing = NO;
//    }
//    if (_curRed <= 0.0) {
//        _curRed = 0.0;
//        _increasing = YES;
//    }
    
    //计算glkView的方向比例
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    //第一个参数是镜头视角  第二个参数是方向比例  第三四个参数代表可见范围，设置近平面距离眼睛4单位，远平面10单位  超过这个范围的图像将不显示
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0f), aspect, 3.0f, 15.0f);
    //设置效果转化属性的投影矩阵
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    
    //创建沿z轴后移6个单位的矩阵   默认是0  也就是默认的（0，0，0）点是在当前屏幕中心
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
    //        _rotation += 90 * self.timeSinceLastUpdate;
    //进行旋转
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotationX), 1, 0, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotationY), 0, 1, 0);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    
    
//    self.effect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(6, 6, 6, 0, 0, 0, 0, 1, 0);

    
}

#pragma mark - glkViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    //清空和渲染背景
    glClearColor(_curR, _curG, _curB, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glClear(GL_DEPTH_BUFFER_BIT);
    glClear(GL_STENCIL_BUFFER_BIT);
    
    //该操作是同步的 必须在drawRect方法中进行
    [self.effect prepareToDraw];
    

    //  1rst attribute buffer : vertices
    /*    glVertexAttribPointer
     第一个参数定义要设置的属性名。我们就使用预定义的GLKit常量。
     第二个参数定义了每个顶点有多少个值。如果你往回看看顶点的结构，你会看到对于位置，有3个浮点值(x, y, z)，对于颜色有4个浮点值(r, g, b, a)。
     第三个参数定义了每个值的类型-对于位置和颜色都是浮点型。
     第四个参数通常都是false。
     第五个参数是跨度（stride）的大小，简单点说就是包含每个顶点的数据结构的大小。所以我们可以简单地传进sizeof(Vertex)，让编译器帮助我们计算它。
     最后一个参数是在数据结构中要获得此数据的偏移量。我们使用方便的offsetof操作来找到结构体中一个具体属性（就是从Vertex数据结构中，找到“位置”信息的偏移量）。
     所以现在我们为GLKBaseEffect传递了位置和颜色数据，还剩下一步了：
     */
    
    //开启对应的顶点属性
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //设置合适的格式从buffer里面读取数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Normal));
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, texture));
    
    /*  draw
        第一个参数定义了绘制定点的方法，GL_TRIANGLES是最通用的
        第二个参数是要渲染的顶点的数量
        第三个参数是所以数组中每个索引的数据类型。
        最后一个参数应该是一个指向索引的指针。
     */
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
    
    
}

//Image和buffer互转
/*
- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{
    NSDictionary *options = @{
                              (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary]
                              };
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = CGImageGetWidth(image);
    CGFloat frameHeight = CGImageGetHeight(image);
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           frameWidth,
                                           frameHeight),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
    
    //    NSDictionary *options = @{
    //                              (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
    //                              (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
    //                              (NSString*)kCVPixelBufferIOSurfacePropertiesKey: [NSDictionary dictionary]
    //                              };
    //
    //
    //    CVPixelBufferRef pxbuffer = NULL;
    //
    //    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, CGImageGetWidth(image),
    //                                          CGImageGetHeight(image), kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef)options,
    //                                          &pxbuffer);
    //    if (status!=kCVReturnSuccess) {
    //        NSLog(@"Operation failed");
    //    }
    //
    //    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    //
    //    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    //    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    //
    //    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGContextRef context = CGBitmapContextCreate(pxdata, CGImageGetWidth(image),
    //                                                 CGImageGetHeight(image), 8, 4*CGImageGetWidth(image), rgbColorSpace,
    //                                                 kCGImageAlphaNoneSkipFirst);
    //    NSParameterAssert(context);
    //
    //    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    //    CGAffineTransform flipVertical = CGAffineTransformMake( 1, 0, 0, -1, 0, CGImageGetHeight(image) );
    //    CGContextConcatCTM(context, flipVertical);
    //    CGAffineTransform flipHorizontal = CGAffineTransformMake( -1.0, 0.0, 0.0, 1.0, CGImageGetWidth(image), 0.0 );
    //    CGContextConcatCTM(context, flipHorizontal);
    //
    //    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
    //                                           CGImageGetHeight(image)), image);
    //    CGColorSpaceRelease(rgbColorSpace);
    //    CGContextRelease(context);
    //
    //    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    //    return pxbuffer;
}

- (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef {
    CVImageBufferRef imageBuffer =  pixelBufferRef;
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
    
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    
    //    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    //    image = [UIImage imageWithData:imageData];
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
}

*/
@end