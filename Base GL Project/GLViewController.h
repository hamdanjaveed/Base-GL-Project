//
//  GLViewController.h
//  Base GL Project
//
//  Created by Hamdan Javeed on 2013-06-30.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface GLViewController : GLKViewController {
    GLuint vertexBufferHandle;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@end
