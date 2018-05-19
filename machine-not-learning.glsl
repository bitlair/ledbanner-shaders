float PI = 3.14159;
void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 uv = (fragCoord.xy - iResolution.xy * .5) / max(iResolution.x, iResolution.y);
	uv *= 2;

	vec2 pol = mod(vec2(
				distance(uv, vec2(0.5, 0.5)) * (0.1 + 0.2 * mod(iTime * 0.2, 5.0) ),
				PI + atan(uv.y, uv.x)/PI
				), 1.0);
	vec2 mid = fract(uv + pol * floor(30.0 * pol.x) + vec2(sin(mod(iTime, 2.0)-1.0)));
	float r = 1.0 - distance(uv, mid);
	vec4 c = vec4(0.06 / fract(r + pol.x),
			0.02 / fract(r + pol.y),
			0.01 / fract(r + uv.x),
			1.0);

	fragColor = c;
}

// https://www.shadertoy.com/view/MtjfR3
