#ifdef GL_ES
precision mediump float;
#endif
// mods by dist, shrunk slightly by @danbri

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
void main(void) {
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos -= .5;
	vec3 color = vec3(0.0);
	for( float i = 0.; i < 6.; ++i ) {
		uPos.y += sin( uPos.x*(i) + (time * i * i * .1) ) * 0.3;
		float fTemp = abs(1.0 / uPos.y / 50.0);
		//vertColor += fTemp;
		color += (.5 + .5 * sin(i+time * 5.)) * vec3( fTemp*(3.0-i)/7.0, fTemp*i/10.0, pow(fTemp,1.0)*1.0 );
	}
	gl_FragColor = vec4(color, 5.0);
}
