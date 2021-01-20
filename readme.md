# 在iOS上如何使用OpenGL给图形添加纹理
在上一篇中，我们了解了如何给图形上色，那么现在我们来做一个更有趣的事情，给图形贴上一张图片（纹理）。

- 加载纹理
- 激活纹理
- 渲染纹理

## 加载纹理
GLKit给我们提供很方变的方法加载一个纹理，如果不用系统的方法的，我也可以自己实现，大致就是读取图片的rgb数据，创建纹理（Texture），将数据传给纹理。
```objc
- (void)setupTexture {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flower" ofType:@"jpg"];
    NSError *theError;
    _flowerTexture = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:&theError];
}
```
我们还需要一个纹理的坐标来告诉OpenGL怎么去显示纹理，纹理的坐标左下角是（0，0）右上角是（1，1），不过有些系统上的图片并不是按这样的坐标存储的，所以当显示的和直接预览的图片效果不一样时，改一下对应的坐标的值就好了。
```objc
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
```

## 激活纹理
在画图形之前，我们激活纹理，并绑定纹理，片段着色器会读取当前激活的纹理。
```
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
```
## 渲染纹理
接收纹理的坐标，并传给片段着色器。
```C
attribute vec3 a_Position;
attribute vec2 a_TexCoord;

varying lowp vec2 TexCoord;

void main(void) {
    gl_Position = vec4(a_Position, 1.0);
    TexCoord = a_TexCoord;
}
```
片段着色器通过纹理的数据和坐标计算出实际的颜色值。
```C
varying lowp vec2 TexCoord;

uniform sampler2D texture0;

void main(void) {
    gl_FragColor = texture2D(texture0, TexCoord);
}
```
运行项目，可以看到一个贴上了两朵花的矩形。
![截图](https://upload-images.jianshu.io/upload_images/3277096-4da823b704dc2fd9.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)


[Github地址](https://github.com/zhonglaoban/OpenGL004)
