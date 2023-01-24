from math import *

sin_1 = 16 * sin(3*pi/16)
cos_1 = 16 * cos(3*pi/16)
sin_2 = 16 * sin(pi/16)
cos_2 = 16 * cos(pi/16)
sin_3 = 16 * sin(3*pi/16)
cos_3 = 16 * cos(3*pi/16)
cos_4 = 16 * cos(pi/4)

#initial
x0 = 64
x1=32
x2=-45
x3=55
x4=64
x5=-10
x6=15
x7=78

#step1
b0 = x0+x7
b1 = x0-x7    
b2 = x3+x4
b3 = x3-x4
b4 = x1+x6
b5 = x1-x6
b6 = x2+x5
b7 = x2-x5

#step2
c0 = cos_1 * b1 - sin_1 * b3
c1 = sin_1 * b1 + cos_1 * b3   

c2 = cos_2 * b5 - sin_2 * b7
c3 = sin_2 * b5 + cos_2 * b7

c4 = (b0 + b2)*16
c5 = (b0 - b2)*16

c6 = (b4 + b6)*16
c7 = (b4 - b6)*16

#step3
d0 = c0 + c1
d1 = c0 - c1
            
d2 = c2 + c3
d3 = c2 - c3

d4 = cos_3 * c5 - sin_3 * c7
d5 = sin_3 * c5 + cos_3 * c7

d6 = c4 + c6
d7 = c4 - c6

#step4
X0 = (cos_4 * d6)
X1 = (cos_4 * (d0 + d2))
X2 = d5
X4 = (cos_4 * d7)/256
X6 = d4/256
X7 = (cos_4 * (d1 + d3))/256
X3 = ((c0 + c3)*16)/256
X5 = ((c1 + c2)*16)/256

print(X0,X1,X2,X3,X4,X5,X6,X7)
