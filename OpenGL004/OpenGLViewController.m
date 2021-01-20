//
//  OpenGLViewController.m
//  OpenGL004
//
//  Created by 钟凡 on 2020/12/11.
//

#import "OpenGLViewController.h"
#import "ZFShader.h"

@interface OpenGLViewController ()

@property (nonatomic, assign) GLuint rectangleVBO;

@property (nonatomic, strong) ZFShader *rectangleShader;
@property (nonatomic, strong) GLKTextureInfo *flowerTexture;

@end

@implementation OpenGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *glView = (GLKView *)self.view;
    glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:glView.context];
    
    [self setupShader];
    [self setupVBO];
    [self setupTexture];
}
- (void)setupShader {
    _rectangleShader = [[ZFShader alloc] initWithVertexShader:@"rectangle.vs" fragmentShader:@"rectangle.fs"];
}
- (void)setupVBO {
    GLfloat rectangleVertices[] = {
        //position       texcoord
        -0.4, -0.4, 0.0, 0.0, 0.0,
        -0.4, -0.8, 0.0, 0.0, 1.0,
         0.4, -0.8, 0.0, 1.0, 1.0,
         0.4, -0.4, 0.0, 1.0, 0.0,
    };
    glGenBuffers(1, &_rectangleVBO);
    glBindBuffer(GL_ARRAY_BUFFER, _rectangleVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(rectangleVertices), rectangleVertices, GL_STATIC_DRAW);
}
- (void)setupTexture {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flower" ofType:@"jpg"];
    NSError *theError;
    _flowerTexture = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:&theError];
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    GLKView *glView = (GLKView *)self.view;
    [EAGLContext setCurrentContext:glView.context];
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_rectangleShader prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _rectangleVBO);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    
    glActiveTexture(_flowerTexture.target);
    glBindTexture(_flowerTexture.target, _flowerTexture.name);
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}
@end
