
// RayMarcher001.glsl
// original: http://glslsandbox.com/e#36017.0

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 lightpos = vec3(0,0,1);


vec3 rotatey(in vec3 p, float ang)
{
	return vec3(p.x*cos(ang)-p.z*sin(ang), p.y, p.x*sin(ang)+p.z*cos(ang));
}
vec3 rotatex(in vec3 p, float ang)
{
	return vec3(p.x, p.y*cos(ang)-p.z*sin(ang), p.y*sin(ang)+p.z*cos(ang));
}
vec3 rotatez(in vec3 p, float ang)
{
	return vec3(p.x*cos(ang)-p.y*sin(ang), p.x*sin(ang)+p.y*cos(ang), p.z);
}

vec2 rbox(in vec3 p, in vec3 pos, in vec3 ang, float obj)
{
	vec3 b = vec3(0.3,0.3,0.3);
	p -= pos;
	p = rotatey(p, ang.y*time);
	p = rotatex(p, ang.x*time);
	p = rotatez(p, ang.z*time);
	return vec2(length(max(abs(p)-b,0.0)) - 0.1, obj);
}
vec2 sph(in vec3 p, float r, float obj)
{
	return vec2(length(p) - r, obj);
}

vec2 min2(vec2 o1, vec2 o2)
{
	if (o1.x < o2.x)
		return o1;
	else
		return o2;
}
vec2 scene(in vec3 p)
{
	vec2 d = sph(p+vec3(0.0, 0.2+sin(time*2.0),+0.0), 0.5+0.2*sin(time), 4.0);
	d = min2(d, rbox(p,vec3(+0.2+sin(time*2.0),+0.0,+0.0), vec3(0.5,-0.5,0.5), 3.0));
	d = min2(d, rbox(p,vec3(+0.5+sin(time*1.5),-0.2,-0.2), vec3(-0.5,0.25,0.65), 2.0));
	d = min2(d, rbox(p,vec3(+0.7,+0.3+sin(time*1.3),+0.5), vec3(-0.5,-0.65,1.5), 2.0));
	d = min2(d, rbox(p,vec3(-0.8,-0.2+sin(time),-0.0+sin(time)), vec3(0.2,0.5,0.5), 2.0));
	d = min2(d, rbox(p,vec3(+1.6,+0.5,-0.1+sin(time)), vec3(0.5,0.75,-0.5), 2.0));

	return d;
}

vec3 get_normal(in vec3 p)
{
	vec3 eps = vec3(0.0001, 0, 0);
	float nx = scene(p + eps.xyy).x - scene(p - eps.xyy).x;
	float ny = scene(p + eps.yxy).x - scene(p - eps.yxy).x;
	float nz = scene(p + eps.yyx).x - scene(p - eps.yyx).x;
	return normalize(vec3(nx,ny,nz));
}

float softshadow(in vec3 ro, in vec3 rd)
{
	vec3 pos = ro;
	float shade = 0.0;
	for (int i = 0; i < 8; i++) {
		vec2 d = scene(pos);
		pos += rd*d.x;
		shade += (1.0 - shade)*clamp(d.x, 0.0, 0.90);
	}
	return shade;
}

float ao(in vec3 ro, in vec3 rd)
{
	vec3 pos = ro;
	float shade = 1.0;
	for (int i = 0; i < 5; i++) {
		vec2 d = scene(pos);
		pos += rd*d.x;
		shade -= d.x*pow(2.0, 0.5*float(i));
	}
	return shade;
}

vec3 rm2(in vec3 ro, in vec3 rd)
{
	vec3 color = vec3(0.0);
	vec3 contrib = vec3(0);
	vec3 pos = ro;
	float dist = 0.0;
	vec2 d;
	for (int i = 0; i < 32; i++) {

		d = scene(pos);
		pos += rd*d.x*1.0;
		dist += d.x*1.0;
		if (dist < 100.0 && abs(d.x) < 0.010) {
			vec3 n = get_normal(pos);
			vec3 l = normalize(lightpos - pos);
			vec3 r = reflect(rd, n);
			float shade = 0.0;
			float diff = clamp(dot(n, l), 0.0, 1.0);
			float spec = pow(clamp(dot(r, l), 0.0, 1.0), 128.0);
			color += shade*vec3(1,1,1)+diff*vec3(1,1,1)*0.8 + spec*vec3(1,1,1);


		}
	}
	color /= 32.0;

	return color;
}

void main( void ) {
	vec2 p = gl_FragCoord.xy / max(resolution.x, resolution.y) - 0.5;
	p *= 2.0;
	p.y += 0.7;

	vec3 color = vec3(0.0);
	vec3 contrib = vec3(0.0);
	vec3 ro = vec3(0.0,0,2.0);
	vec3 rd = normalize(vec3(p.x,p.y,-1.0));


	vec3 pos = ro;
	float dist = 0.0;
	vec2 d;
	for (int i = 0; i < 64; i++) {

		d = scene(pos);
		pos += rd*d.x*1.0;
		dist += d.x*1.0;

	}
	if (dist < 100.0 && d.x < 0.001) {
		vec3 n = get_normal(pos);
		vec3 l = normalize(lightpos - pos);
		vec3 r = reflect(rd, n);
		float diff = clamp(dot(n, l), 0.0, 1.0);
		float shade = smoothstep(0.0, 1.0, 1.0 - ao(pos+0.01*n, 0.5*n));
		float spec = pow(clamp(dot(r, l), 0.0, 1.0), 128.0);
		vec3 refl = rm2(pos+0.01*n, r);
		float shadow = clamp(softshadow(pos+0.01*n, l), -1.0, 1.0);
		if (d.y > 0.5 && d.y < 1.5)   color += contrib+shadow*shade*vec3(1,1,1)+diff*vec3(1,1,1)*0.5;
		else if (d.y == 3.0)          color += contrib+shadow*shade*vec3(0,1,1)+diff*vec3(0,1,1)*0.5 + spec*vec3(0,1,1)*1.0+refl*vec3(0,1,1)*0.4;
		else if (d.y == 4.0)          color += contrib+shadow*shade*vec3(0.3,1,0.2)+diff*vec3(0,1,1)*0.5 + spec*vec3(0,1,1)*1.0+refl*vec3(0,1,1)*0.4;
		else                          color += contrib+shadow*shade*vec3(1,1,1)+diff*vec3(1,0,0)*0.5 + spec*vec3(1,1,1)*1.0+refl*vec3(1,1,1)*0.4;
	}

	gl_FragColor = vec4(color, 1.0);
}
