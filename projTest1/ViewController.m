//
//  ViewController.m
//  projTest1
//
//  Created by THM on 5/21/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "ViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#define MIN_ZOOM -20.0f
#define MAX_ZOOM 0.0f
#define PERSPECTIVE_ANGLE 80.0f

@interface ViewController () {
    GLuint _program, _program2;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    
    GLKMatrix4 _modelView[3];
    GLKMatrix3 _normal[3];
    
    GLKMatrix4 nodeModelView[NUM_NODES];
    GLKMatrix3 nodeNormal[NUM_NODES];
    
    
    float _rotationX, _rotationY, _rotation[2];
    float _translate[3];
    float _zValue;
    
    GLuint _vertexArray, _connectArray;
    GLuint _vertexBuffer, _connectBuffer;
    
    //UILabel* label;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;
- (void)panRecognizer: (UIPanGestureRecognizer *)recognizer;
- (void)pinchRecognizer: (UIPinchGestureRecognizer *)recognizer;

- (BOOL)setupNodes;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init Values
    //_rotation = 0.0f;
    _zValue = -10.0f;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRecognizer:)];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    // generate or load the node data
    BOOL check = [self setupNodes];
    if(!check){
        NSLog(@"Could not generate Node data successfully");
        exit(1);
    }
    
    // setup the gl screen
    [self setupGL];
    
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}


// function to modify camera position when user slides finger on screen
-(void)panRecognizer: (UIPanGestureRecognizer *)recognizer
{
    CGPoint translate = [recognizer translationInView:self.view];
    CGPoint prevTranslate;
    
    if(UIGestureRecognizerStateBegan){

    }
    
    if(UIGestureRecognizerStateChanged){

        if(recognizer.numberOfTouches == 1){
            //_rotationX += translate.x * 0.01f;
            //_rotationY += translate.y * 0.001f;
            
            _rotation[0] += translate.x * -0.01f;
            if(_rotation[0] >= 2*PI) _rotation[0] = 0;
            
            _rotation[1] += translate.y * 0.001f;
            if(_rotation[1] >= 2*PI) _rotation[1] = 0;
        }
        
        if(recognizer.numberOfTouches == 2){
            
            if(translate.x - prevTranslate.x > 20.5) _translate[0] += 0.1f;
            if(translate.x - prevTranslate.x < -20.5) _translate[0] -= 0.1f;
            
            if(translate.y - prevTranslate.y < -20.5) _translate[1] += 0.1f;
            if(translate.y - prevTranslate.y > 20.5) _translate[1] -= 0.1f;
            
            //_translate[0] = translate.x * 0.01f;
            //_translate[1] = -translate.y * 0.01f;
            
            prevTranslate = translate;
        }
        
    }
    
    if(UIGestureRecognizerStateEnded){
        [self loadLineData];
        NSLog(@"PAN: %f    %f", translate.x, translate.y);
    }
    /*if(translate.x >0)_rotationX += 0.01;
    if(translate.x <0)_rotationX -= 0.01;
    if(translate.y >0)_rotationY += 0.01;
    if(translate.y <0)_rotationY -= 0.01;*/
}

// function to modify camera zoom when user pinches screen
-(void)pinchRecognizer: (UIPinchGestureRecognizer *)recognizer
{
    static float lastScale = 0.0f;
    
    NSLog(@"Pinch scale: %f", recognizer.scale);
    //CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
    // you can implement any int/float value in context of what scale you want to zoom in or out
        
    if(recognizer.scale > lastScale){
        if(_zValue < MAX_ZOOM) _zValue += 0.1;
        lastScale = recognizer.scale;
    }
    
    if(recognizer.scale < lastScale){
        if(_zValue > MIN_ZOOM) _zValue -= 0.1;
        lastScale = recognizer.scale;
    }
    //_zValue += recognizer.scale * 0.1;
}

-(void) tapRecognizer: (UITapGestureRecognizer *) recognizer
{
    CGPoint touch = [recognizer locationInView:self.view];
    //NSLog(@"TAP: %f   %f", (float)touch.x, (float)touch.y);
    
    int pixelsXY[2];
    pixelsXY[0] = (int)self.view.bounds.size.width;  // 768
    pixelsXY[1] = (int)self.view.bounds.size.height; // 1024
    
    int touchXY[2];
    touchXY[0] = (int)touch.x;
    touchXY[1] = (int)touch.y;
    
    //float screenXY[2];
    
    BOOL touched = false;
    float zCurrent = _zValue;
    float point[3];
    int closestTouchedNode = NUM_NODES; // no node numbered NUM_NODES: zero indexxed arrays
    
    for(int i=0; i<NUM_NODES; i++){
        touched = [_nodes[i] detectSelectedWithZVal:_zValue withAngle:PERSPECTIVE_ANGLE andDeltaXAndDeltaY:touchXY andPixels:pixelsXY];
        
        if(touched){
            
            [_nodes[i] getTransformedPoint:point];
            if(point[2] > zCurrent){
                closestTouchedNode = i;
                zCurrent = point[2];
            }
            NSLog(@"TOUCHED!!! %d", i);
        }
        else NSLog(@"not touched %d", i);
    }
    
    if(UIGestureRecognizerStateEnded){
        if(closestTouchedNode != NUM_NODES)
            [_nodes[closestTouchedNode] setClosestTouchedNode:TRUE];
    
        for(int i=0; i<NUM_NODES; i++){
            
            if([_nodes[i] isClosestTouchedNode])
                NSLog(@"closest touched node: %d", closestTouchedNode);
        }
    }
    //float nodes[3];
    /*for(int i=0; i<NUM_NODES; i++){
        [_nodes[i] getTransformedPoint: nodes];
        NSLog(@"pos%d: %f   %f   %f", i, nodes[0], nodes[1], nodes[2]);
        NSLog(@"%f", _zValue);
    }*/
    //NSLog(@"TAPPED");
    
}


-(void) loadLineData
{
    GLfloat tempPointData[3];
    
    // generate all the point data of all the vertices and store in vertex data array
    for(int i=0; i<NUM_NODES; i++){
        
        [_nodes[i] getTransformedPoint: tempPointData];
        
        _lineVertexData[i*3 + 0] = tempPointData[0];
        _lineVertexData[i*3 + 1] = tempPointData[1];
        _lineVertexData[i*3 + 2] = tempPointData[2];
    }
    
    // record all indices of the points that will be joint together, as lines
    // store in index data array
    for(int i=0; i<NUM_NODES; i++){
        for(int j=i; j<NUM_NODES; j++){
            _lineIndexData[i*NUM_NODES*2 + j*2 + 0] = (GLuint)i;
            _lineIndexData[i*NUM_NODES*2 + j*2 + 1] = (GLuint)j;
        }
    }
    // bind node links data to _connectArray buffer
    glGenVertexArraysOES(1, &_connectArray);
    glBindVertexArrayOES(_connectArray);
    
    glGenBuffers(1, &_connectBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _connectBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_lineVertexData), _lineVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 12, BUFFER_OFFSET(0));

}

-(BOOL)setupNodes
{

    float pt[3];
    float col[4] = {1.0, 0.4, 0.4, 1.0};
    float size = 0.2;

    for(int i=0; i<NUM_NODES; i++){
        float ptX = ((float)rand()/RAND_MAX) * 10 - 3;
        float ptY = ((float)rand()/RAND_MAX) * 10 - 5;
        float ptZ = ((float)rand()/RAND_MAX) * 10 - 7;
        
        pt[0] = ptX;
        pt[1] = ptY;
        pt[2] = ptZ;
        
        //pt[0] = 0.0f;
        //pt[1] = 0.0f;
        //pt[2] = 0.0000001f;
        Node* node = [[Node alloc] initPoint:pt colour:col size:size];
        _nodes[i] = node;
    }
    
    //[self loadLineData];
    
    return YES;
}

// function that loads data for drawing a sphere using GL_TRIANGLES
// first load vertex data (position and normal), then load index data of triangles to be drawn 
-(void)generateSphereCoords
{
    Sphere* s = [[Sphere alloc] initWithRows:SPHERE_ROWS andPointsPerRow:SPHERE_POINTS_PER_ROW];
    [s createSphere:_sphereVertexArray withRows:SPHERE_ROWS andPointsPerRow:SPHERE_POINTS_PER_ROW];
    [s calculateIndices:_sphereIndexArray withVertices:_sphereVertexArray];
}

- (void)setupGL
{
    
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    // generate the sphere vertex array, and index array for drawing spheres using GL_TRIANGLES
    [self generateSphereCoords];
    
    glEnable(GL_DEPTH_TEST);
    
    // bind sphere vertex data to _vertexArray buffer
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_sphereVertexArray), _sphereVertexArray, GL_STATIC_DRAW);
    
    // load position and normal data from sphereVertexArray (normal is offset by 3 GL_FLOATs)
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    glBindVertexArrayOES(0);
    
    [self loadLineData];
    /*
    // bind node links data to _connectArray buffer
    glGenVertexArraysOES(1, &_connectArray);
    glBindVertexArrayOES(_connectArray);
    
    glGenBuffers(1, &_connectBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _connectBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_lineVertexData), _lineVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 12, BUFFER_OFFSET(0));
    //glEnableVertexAttribArray(GLKVertexAttribNormal);
    //glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    */
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 44)];
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.4f alpha:1.0f];
    [self.view addSubview:label];
    label.text = @"Hello World";
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(PERSPECTIVE_ANGLE), aspect, 0.1f, 100.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, _zValue);//-10.0f);
    //baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    //baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotationX, 0.0f, 1.0f, 0.0f);
    //baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotationY, 1.0f, 0.0f, 0.0f);
    
    //baseModelViewMatrix = GLKMatrix4Translate(baseModelViewMatrix, _translate[0], _translate[1], _translate[2]);
    
    
    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
    //modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    // Compute the model view matrix for the object rendered with ES2
    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 4.5f);
    //modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    for(int i=0; i<NUM_NODES; i++){
        [_nodes[i] calculateModelView:&nodeModelView[i] andNormal:&nodeNormal[i] withBase:&baseModelViewMatrix andProjection:&projectionMatrix andRotation:_rotation andTranslation:_translate];
    }
    
    //_rotation += self.timeSinceLastUpdate * 0.5f;
    
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{

    
    //glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClearColor(0.95f, 0.92f, 0.8f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // Render the object with GLKit
    //[self.effect prepareToDraw];
        
    // Render the object again with ES2
    glUseProgram(_program);
    
    float tempColour[4];
    
    for(int i=0; i<NUM_NODES; i++){
        [_nodes[i] getColour:tempColour];
        
        glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, nodeModelView[i].m);
        glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, nodeNormal[i].m);
        glUniform4f(uniforms[UNIFORM_COLOUR], tempColour[0], tempColour[1], tempColour[2], tempColour[3]);
        
        // draw each node
        //[_nodes[i] draw:&_vertexArray withIndices:_sphereIndexArray withModelView:&nodeModelView[i] withNormal:&nodeNormal[i] withProgram:&_program];
        glDrawElements(GL_TRIANGLES, sizeof(_sphereIndexArray)/sizeof(_sphereIndexArray[0]), GL_UNSIGNED_INT, _sphereIndexArray);

    }
    
    [self.effect prepareToDraw];
    
    glBindVertexArrayOES(_connectArray);
    
    //glUseProgram(_program);
    
    //glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    //glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    GLuint numIndices = sizeof(_lineIndexData)/sizeof(_lineIndexData[0]);
    glDrawElements(GL_LINES, numIndices, GL_UNSIGNED_INT, _lineIndexData);
    
}


#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);

    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    uniforms[UNIFORM_COLOUR] = glGetUniformLocation(_program, "colour");
    
    /*
    _program2 = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"SelectedNodeShader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"SelectedNodeShader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    glAttachShader(_program2, vertShader);
    glAttachShader(_program2, fragShader);
    
    glBindAttribLocation(_program2, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program2, GLKVertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:_program2]) {
        NSLog(@"Failed to link program: %d", _program2);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program2) {
            glDeleteProgram(_program2);
            _program2 = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program2, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program2, "normalMatrix");
    */
    
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
