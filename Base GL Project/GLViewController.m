//
//  GLViewController.m
//  Base GL Project
//
//  Created by Hamdan Javeed on 2013-06-30.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "GLViewController.h"

@interface GLViewController () <GLKViewDelegate>

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get our view and make sure it's a GLKView
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"GLViewController's view is not a GLKView");
    
    // create a 2.0 context
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // set the current context
    [EAGLContext setCurrentContext:view.context];
    
    // create a GLKBaseEffect and set its properties
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    // make the effect use a white color to render something
    [self.baseEffect setUseConstantColor:GL_TRUE];
    [self.baseEffect setConstantColor:GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f)];
    
    // set the background color
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &vertexBufferHandle);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferHandle);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // tell the GLKBaseEffect to prepare itself for drawing
    [self.baseEffect prepareToDraw];
    
    // clear the frame buffer
    glClear(GL_COLOR_BUFFER_BIT);
    
    // enable the position vertex attribute
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    // tell OpenGL where vertex data is located
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), nil);
    
    // draw the triangle
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices) / sizeof(vertices[0]));
}

- (void)dealloc {
    // set the current context
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
    
    // delete any unneeded buffers
    if (vertexBufferHandle != 0) {
        glDeleteBuffers(1, &vertexBufferHandle);
        vertexBufferHandle = 0;
    }
    
    // stop using the current context
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
