// Lightning
// By: Brandon Fogerty
// bfogerty at gmail dot com
// xdpixel.com


// MORE MODS BY 27


#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 resolution;


float Hash( vec2 p)
{
	vec3 p2 = vec3(p.xy,1.0);
	return fract(sin(dot(p2,vec3(37.1,61.7, 12.4)))*858.5453123);
}

float noise(in vec2 p)
{
	vec2 i = floor(p);
	vec2 f = fract(p);
	f *= f * (3.0-2.0*f);

	return mix(mix(Hash(i + vec2(0.,0.)), Hash(i + vec2(1.,0.)),f.x),
			mix(Hash(i + vec2(0.,1.)), Hash(i + vec2(1.,1.)),f.x),
			f.y);
}

float fbm(vec2 p)
{
	float v = 0.0;
	v += noise(p*1.)*2.200;
	v += noise(p*2.)*0.00025;
	v -= noise(p*4.)*3.125;
	v += noise(p*8.)*.00625;
	v += noise(p*16.)*0.00625;
	return v;
}

void main( void )
{

	vec2 uv = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	uv.x *= resolution.x/resolution.y;
	uv /= max(resolution.x, resolution.y) / 30.0;

	vec3 finalColor = vec3( 0.0 );
	for( int i=1; i < 2; ++i ) {
		float t = abs(2.0 / ((uv.x + fbm( uv + time/float(i)))*75.));
		finalColor +=  t * vec3( float(i) * 6.2 +0.2, 1.2, 13.0 );
	}

	gl_FragColor = vec4( finalColor, 1.0 );
}
