//
//  staticShip.h
//  GLTest
//
//  Created by RRTY on 17/1/18.
//  Copyright © 2017年 chenyan. All rights reserved.
//

#ifndef staticShip_h
#define staticShip_h

typedef struct {
    GLfloat Position[3];    // 坐标：x, y, z
    GLfloat Normal[3];      //法线(用于开启光源)
    GLfloat Color[4];       // 颜色
    GLfloat texture[2];     //纹理坐标  笛卡尔坐标系  与iPhone屏幕坐标系不同
} Vertex;


const Vertex Vertices[] = { //顶点坐标及颜色
    
    //正
    {{ 1, -1,  1}, { 0, 0,  1},    {1, 1, 1, 1}, {1,0} },
    {{-1,  1,  1}, { 0, 0,  1},    {1, 1, 1, 1}, {0,1} },
    {{-1, -1,  1}, { 0, 0,  1},    {1, 1, 1, 1}, {0,0} },
    
    {{ 1, -1,  1}, { 0, 0,  1},    {1, 1, 1, 1}, {1,0} },
    {{ 1,  1,  1}, { 0, 0,  1},    {1, 1, 1, 1}, {1,1} },
    {{-1,  1,  1}, { 0, 0,  1},    {1, 1, 1, 1}, {0,1} },
    
    //上
    {{-1,  1,  1}, { 0, 1,  0},    {0, 1, 0, 1}, {1,0} },
    {{ 1,  1,  1}, { 0, 1,  0},    {0, 1, 0, 1}, {0,1} },
    {{ 1,  1, -1}, { 0, 1,  0},    {0, 1, 0, 1}, {0,0} },
    
    {{-1,  1,  1}, { 0, 1,  0},    {0, 1, 0, 1}, {1,0} },
    {{-1,  1, -1}, { 0, 1,  0},    {0, 1, 0, 1}, {1,1} },
    {{ 1,  1, -1}, { 0, 1,  0},    {0, 1, 0, 1}, {0,1} },
    
    //右
    {{ 1,  1,  1}, { 1, 0,  0},    {1, 1, 0, 1}, {1,0} },
    {{ 1, -1,  1}, { 1, 0,  0},    {1, 1, 0, 1}, {0,1} },
    {{ 1, -1, -1}, { 1, 0,  0},    {1, 1, 0, 1}, {0,0} },
    
    {{ 1,  1,  1}, { 1, 0,  0},    {1, 1, 0, 1}, {1,0} },
    {{ 1,  1, -1}, { 1, 0,  0},    {1, 1, 0, 1}, {1,1} },
    {{ 1, -1, -1}, { 1, 0,  0},    {1, 1, 0, 1}, {0,1} },
    
    //左
    {{-1, -1,  1}, { -1, 0,  0},    {1, 0, 0, 1}, {1,0} },
    {{-1, -1, -1}, { -1, 0,  0},    {1, 0, 0, 1}, {0,1} },
    {{-1,  1, -1}, { -1, 0,  0},    {1, 0, 0, 1}, {0,0} },
    
    {{-1, -1,  1}, { -1, 0,  0},    {1, 0, 0, 1}, {1,0} },
    {{-1,  1,  1}, { -1, 0,  0},    {1, 0, 0, 1}, {1,1} },
    {{-1,  1, -1}, { -1, 0,  0},    {1, 0, 0, 1}, {0,1} },
    
    //下
    {{ 1, -1,  1}, { 0, -1,  0},    {0, 1, 1, 1}, {1,0} },
    {{-1, -1,  1}, { 0, -1,  0},    {0, 1, 1, 1}, {0,1} },
    {{ 1, -1, -1}, { 0, -1,  0},    {0, 1, 1, 1}, {0,0} },
    
    {{ 1, -1, -1}, { 0, -1,  0},    {0, 1, 1, 1}, {1,0} },
    {{-1, -1, -1}, { 0, -1,  0},    {0, 1, 1, 1}, {1,1} },
    {{-1, -1,  1}, { 0, -1,  0},    {0, 1, 1, 1}, {0,1} },
    
    //后
    {{ 1, -1, -1}, { 0, 0, -1},    {1, 0, 1, 1}, {1,0} },
    {{-1,  1, -1}, { 0, 0, -1},    {1, 0, 1, 1}, {0,1} },
    {{-1, -1, -1}, { 0, 0, -1},    {1, 0, 1, 1}, {0,0} },
    
    {{ 1, -1, -1}, { 0, 0, -1},    {1, 0, 1, 1}, {1,0} },
    {{ 1,  1, -1}, { 0, 0, -1},    {1, 0, 1, 1}, {1,1} },
    {{-1,  1, -1}, { 0, 0, -1},    {1, 0, 1, 1}, {0,1} },
    
    //底座
    //上
    {{ 1.5, -1.2,  1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.2,  1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{ 1.5, -1.2, -1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    
    {{-1.5, -1.2, -1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.2,  1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{ 1.5, -1.2, -1.5}, { 0, 1,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    
    //前
    {{ 1.5, -1.2,  1.5}, { 0, 0,  1},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.2,  1.5}, { 0, 0,  1},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.5,  1.5}, { 0, 0,  1},       {0.6, 0.6, 0.6, 1},{0,0}},
    
    {{ 1.5, -1.2,  1.5}, { 0, 0,  1},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{ 1.5, -1.5,  1.5}, { 0, 0,  1},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.5,  1.5}, { 0, 0,  1},       {0.6, 0.6, 0.6, 1},{0,0}},
    
    //后
    {{ 1.5, -1.2, -1.5}, { 0, 0, -1},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.2, -1.5}, { 0, 0, -1},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.5, -1.5}, { 0, 0, -1},       {0.6, 0.6, 0.6, 1},{0,0}},
    
    {{ 1.5, -1.2, -1.5}, { 0, 0, -1},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{ 1.5, -1.5, -1.5}, { 0, 0, -1},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.5, -1.5}, { 0, 0, -1},       {0.6, 0.6, 0.6, 1},{0,0}},
    
    //左
    {{-1.5, -1.2,  1.5}, { -1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.2, -1.5}, { -1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.5, -1.5}, { -1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    
    {{-1.5, -1.2,  1.5}, { -1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.5,  1.5}, { -1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{-1.5, -1.5, -1.5}, { -1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    
    //右
    {{ 1.5, -1.2,  1.5}, { 1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{ 1.5, -1.2, -1.5}, { 1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{ 1.5, -1.5, -1.5}, { 1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    
    {{ 1.5, -1.2,  1.5}, { 1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{ 1.5, -1.5,  1.5}, { 1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
    {{ 1.5, -1.5, -1.5}, { 1, 0,  0},       {0.6, 0.6, 0.6, 1},{0,0}},
 
};

const GLubyte Indices[] = { // 数组元素值对应的是顶点在Vertices数组中的下标。

    //正
    0, 1, 2, // 每一个行对应组成三角形的3个顶点
    3, 4, 5,
    //上
    6, 7, 8,
    9, 10,11,
    //右
    12,13,14,
    15,16,17,
    //左
    18,19,20,
    21,22,23,
    //下
    24,25,26,
    27,28,29,
    //后
    30,31,32,
    33,34,35,
    
    //底座上
    36,37,38,
    39,40,41,
    //底座前
    42,43,44,
    45,46,47,
    //底座后
    48,49,50,
    51,52,53,
    //底座左
    54,55,56,
    57,58,59,
    //底座右
    60,61,62,
    63,64,65,
};


#endif /* staticShip_h */
