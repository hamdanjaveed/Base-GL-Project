//
//  GLViewController.m
//  Base GL Project
//
//  Created by Hamdan Javeed on 2013-06-30.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "GLViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexBufferObject.h"

@interface GLViewController () <GLKViewDelegate>
@property (strong, nonatomic) AGLKVertexBufferObject *triangleVBO;
@end

@implementation GLViewController

typedef struct {
    GLKVector3 position;
} SceneVertex;

static const SceneVertex vertices[] = {
    // lower left corner
    {{-0.5f, -0.5f, 0.0f}},
    // lower right corner
    {{ 0.5f, -0.5f, 0.0f}},
    // upper left corner
    {{-0.5f,  0.5f, 0.0f}}
};

- (AGLKVertexBufferObject *)triangleVBO {
    if (!_triangleVBO) {
        _triangleVBO = [[AGLKVertexBufferObject alloc] initWithStride:sizeof(SceneVertex)
                                                     numberOfVertices:sizeof(vertices) / sizeof(vertices[0])
                                                                 data:vertices
                                                             andUsage:GL_STATIC_DRAW];
    }
    return _triangleVBO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get our view and make sure it's a GLKView
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"GLViewController's view is not a GLKView");
    
    // create a 2.0 context
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // set the current context
    [AGLKContext setCurrentContext:view.context];
    
    // create a GLKBaseEffect and set its properties
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    // make the effect use a white color to render something
    [self.baseEffect setUseConstantColor:GL_TRUE];
    [self.baseEffect setConstantColor:GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f)];
    
    // set the background color
    [((AGLKContext *)view.context) setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f)];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // tell the GLKBaseEffect to prepare itself for drawing
    [self.baseEffect prepareToDraw];
    
    // clear the frame buffer
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    
    [self.triangleVBO prepareToDrawWithAttribute:GLKVertexAttribPosition
                             numberOfCoordinates:sizeof(vertices) / sizeof(vertices[0])
                              offsetOfFirstIndex:0
                  andShouldEnableVertexAttribute:YES];
    
    [self.triangleVBO drawArrayWithMode:GL_TRIANGLES
                       startVertexIndex:0
                    andNumberOfVertices:sizeof(vertices) / sizeof(vertices[0])];
}

- (void)dealloc {
    // set the current context
    [AGLKContext setCurrentContext:((GLKView *)self.view).context];
    
    self.triangleVBO = nil;
    
    // stop using the current context
    ((GLKView *)self.view).context = nil;
    [AGLKContext setCurrentContext:nil];
}

@end
