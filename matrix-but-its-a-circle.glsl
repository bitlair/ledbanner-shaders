
#ifdef GL_ES
precision mediump float;
#extension GL_OES_standard_derivatives : enable
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// ----------------------------------------------------------------------------------------------------

// variation of https://www.shadertoy.com/view/MscXWM
// in the taste of http://9gag.com/gag/am9peXo

#define TAU 6.283185307179586
#define A  26.*fract(time*0.0002)*a + time
#define d  O += 0.1*(1.+cos(A)) / length(vec2( fract(a*k*150./TAU)-.5, 16.*(length(U)-.1*k*sin(A)-1.5*k))); a += TAU;
#define c d d d k+=0.65*k;

void mainImage( out vec4 O, vec2 U, vec2 iResolution )
{
	U = (U+U-(O.xy=iResolution.xy))/O.x;
	float a = atan(U.x,U.y), k=0.125;
	O -= O;
	c c c c
		O *= O;
	O.y = length(O);
}

// ----------------------------------------------------------------------------------------------------

void main( void ) {
	mainImage( gl_FragColor, gl_FragCoord.xy, resolution );
}
