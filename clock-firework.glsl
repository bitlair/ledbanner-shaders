// "Fireworks" by Martijn Steinrucken aka BigWings - 2015
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported
// License.
// Email:countfrolic@gmail.com Twitter:@The_ArtOfCode

// Adaptation for Bitlair's LED-Banner by polyfloyd

#pragma map font=image:./res/ascii.png

#define PI 3.141592653589793238

#define B(x,y,z,w) (smoothstep(x-z, x+z, w)*smoothstep(y+z, y-z, w))

#define NUM_EXPLOSIONS 32.
#define NUM_PARTICLES 70.

// <Fireworks>
#define MOD3 vec3(.1031,.11369,.13787)

vec3 hash31(float p) {
	vec3 p3 = fract(vec3(p) * MOD3);
	p3 += dot(p3, p3.yzx + 19.19);
	return fract(vec3((p3.x + p3.y)*p3.z, (p3.x+p3.z)*p3.y, (p3.y+p3.z)*p3.x));
}

float hash12(vec2 p){
	vec3 p3  = fract(vec3(p.xyx) * MOD3);
	p3 += dot(p3, p3.yzx + 19.19);
	return fract((p3.x + p3.y) * p3.z);
}

float circ(vec2 uv, vec2 pos, float size) {
	uv -= pos;

	size *= size;
	return smoothstep(size*1.1, size, dot(uv, uv));
}

float light(vec2 uv, vec2 pos, float size) {
	uv -= pos;
	size *= size;
	return size/dot(uv, uv);
}

vec3 explosion(vec2 uv, vec2 p, float seed, float t) {
	vec3 col = vec3(0.);

	vec3 en = hash31(seed);
	vec3 baseCol = en;
	for(float i=0.; i<NUM_PARTICLES; i++) {
		vec3 n = hash31(i)-.5;

		vec2 startP = p-vec2(0., t*t*.1);        
		vec2 endP = startP+normalize(n.xy)*n.z;


		float pt = 1.-pow(t-1., 2.);
		vec2 pos = mix(p, endP, pt);    
		float size = mix(.01, .005, smoothstep(0., .1, pt));
		size *= smoothstep(1., .1, pt);

		float sparkle = (sin((pt+n.z)*100.)*.5+.5);
		sparkle = pow(sparkle, pow(en.x, 3.)*50.)*mix(0.01, .01, en.y*n.y);

//		size += sparkle*B(.6, 1., .1, t);
		size += sparkle*B(en.x, en.y, en.z, t);

		col += baseCol*light(uv, pos, size);
	}

	return col;
}

vec3 rainbow(vec3 c, float t) {
	float avg = (c.r+c.g+c.b)/3.;
	c = avg + (c-avg)*sin(vec3(0., .333, .666)+t);
	c += sin(vec3(.4, .3, .3)*t + vec3(1.1244,3.43215,6.435))*vec3(.4, .1, .5);
	return c;
}

vec4 fireworks(vec2 fragCoord, float t) {
	vec2 uv = fragCoord.xy / iResolution.xy;
	uv.x -= .5;
	uv.y /= iResolution.x/iResolution.y;

	float n = hash12(uv+10.);

	vec3 c = vec3(0.);

	for (float i=0.; i<NUM_EXPLOSIONS; i++) {
		float et = t+i*1234.45235;
		float id = floor(et);
		et -= id;

		vec2 p = hash31(id).xy;
		p.x -= .5;
		p.x *= 1.6;
		c += explosion(uv, p, id, et);
	}
	c = rainbow(c, t*2);

	return vec4(c, 1);
}
// </fireworks>

vec4 ascii(vec2 uv, int char) {
	vec2 charPos = vec2(char % 16, 15 - char / 16) / 16;
	return texture2D(font, (charPos + clamp(uv*.5+.5, 0, 1) / 16) * vec2(1, -1));
}

int imod(int n, int d) {
	return int(mod(n, d));
}

float text(vec2 uv, float time) {
	int s = int(iDate.w) + 1;
	int seconds = imod(s, 60);
	int minutes = imod(s / 60, 60);
	int hours   = imod(s / (60*60) + 1, 24);
	int text[8]; // HH:MM:SS
	text[0] = 0x30 + imod(hours/10, 10);   // H
	text[1] = 0x30 + imod(hours, 10);      // H
	text[2] = 0x3a; // :
	text[3] = 0x30 + imod(minutes/10, 10); // M
	text[4] = 0x30 + imod(minutes, 10);    // M
	text[5] = 0x3a; // :
	text[6] = 0x30 + imod(seconds/10, 10); // S
	text[7] = 0x30 + imod(seconds, 10);    // S

	const float numShown = 10;
	const int xoffset = 1;

	vec4 face = vec4(0);
	int charPos = int(floor((uv.x) * numShown - xoffset));
	if (uv.x > (xoffset / numShown) && charPos < text.length()) {
		int char = text[charPos];
		vec2 charUV = vec2(mod(uv.x * numShown, 1), uv.y) * 2 - 1;
		face = ascii(charUV * 0.8, char);
	}
	return clamp(face.r * 16, 0, 1);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 uv = fragCoord / iResolution.xy;

	vec4 fw = fireworks(fragCoord, iTime+60);
	float tx = text(uv, iTime);

	vec4 color = vec4(0, 0, 0, 1);
	color.rgb = mix(color.rgb, fw.rgb, fw.a);
	color.rgb = mix(color.rgb, 1-fw.rgb, tx);
	fragColor = color;
}
