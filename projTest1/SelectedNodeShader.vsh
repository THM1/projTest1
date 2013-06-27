//
//  SelectedNodeShader.vsh
//  projTest1
//
//  Created by THM on 5/21/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec4 colour;

varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    
    vec4 diffuseColor = colour; //vec4(1.0, 0.4, 0.4, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    colorVarying = diffuseColor * nDotVP;
    gl_Position = modelViewProjectionMatrix * position;
    
}
