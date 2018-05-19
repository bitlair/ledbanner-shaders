float chebyshev(float x, int n){
	const int MAX_POWER = 16;
	vec2 tvec = vec2( 1., x);
	mat2 m = mat2 (0., -1., 1., 2.*x);
	for( int i = 2; i < MAX_POWER; i += 1){
		if( i > n ) return tvec.y;
		tvec = m*tvec;
	}
	return tvec.y;
}

//https://github.com/hughsk/glsl-hsv2rgb/blob/master/index.glsl
vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord / max(iResolution.x, iResolution.y);
	uv *= 2.5;
	uv.x -= 1.2;
	uv.y -= 0.5;

	float timex = iTime * .21;
	float tx = cos(timex)*chebyshev(uv.x, 2)  + sin(timex)* chebyshev(uv.x, 5) ;
	float timey = iTime * 0.2;
	float ty = cos(timey)*chebyshev(uv.y, 3) + sin(timey)* chebyshev(uv.y, 7) ;

	float t2 = iTime * .5;
	float csigma = cos(t2);
	float s2sigma = 1. - csigma*csigma;
	//next formula was taken from this paper
	//http://boj.pntic.mec.es/~jcastine/Trabajos%20matematicos_archivos/cmj122-127.pdf
	float b = tx*tx + ty*ty - 2.0*tx*ty*csigma + s2sigma;
	float w = 3.*fwidth(b);
	//float w = .2;

	b *= 2.;
	float bFloor = floor(b);
	b = smoothstep(w,0.,abs(fract(b) -.5))/fwidth(b);

	//b*= step(abs(uv.x), 1.);
	//b*= step(abs(uv.y), 1.);

	vec3 color = hsv2rgb(vec3(bFloor/10.+fract(iTime*0.1),1.,1.));

	color *= b;

	fragColor = vec4(color, 1.0);
}

// https://www.shadertoy.com/view/MtBBRG
