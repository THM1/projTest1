//
//  Shader.fsh
//  projTest1
//
//  Created by THM on 5/21/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
