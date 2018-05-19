// Guyver
#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform float lowFreq;
uniform vec2 resolution;


vec3 SUN_1 = vec3(0.0,0.5,1.0);
vec3 SUN_2 = vec3(1.0,0.0,0.0);
vec3 SUN_3 = vec3(0.1,1.0,0.753);
vec3 SUN_4 = vec3(0.6,0.8,0.0);


float sigmoid(float x)
{
	return 1.5/(1. + exp2(-x)) - 1.;
}


void main( void ) 
{
	vec2 position = gl_FragCoord.xy * 4.0;
	vec2 aspect = vec2(resolution/resolution );
	position -= 0.5*resolution;
	vec2 position2 = 0.5 + (position-0.5)/resolution*3.;
	position *= .05;
	position2 *= .05;
	float filter = sigmoid(pow(2.,7.5)*(length((position/resolution + 0.5)*aspect) - 0.015))*0.5 +0.5 +lowFreq*lowFreq;
	position = mix(position, position2, filter) - 0.5;

	vec3 color = vec3(0.);
	float angle = atan(position.y,position.x);
	float d = length(position);
	float t = time * .5;
	color += 0.08/length(vec2(.05,2.0*position.y+sin(position.x*10.+t*-6.)))*SUN_3; 
	color += 0.07/length(vec2(.06,4.0*position.y+sin(position.x*10.+t*-2.)))*SUN_1; // I'm sure there's an easier way to do this, this just happened to look nice and blurry.
	color += 0.06/length(vec2(.07,8.0*position.y+sin(position.x*10.+t*2.)))*SUN_2;
	color += 0.05/length(vec2(.08,16.0*position.y+sin(position.x*10.+t*6.)))*SUN_3;
	color += 0.04/length(vec2(.09,32.0*position.y+sin(position.x*10.+t*10.)))*SUN_4;
	
	gl_FragColor = vec4(color, 1.0);
}

