mat2 rotate(float angle)
{
	float c = cos(angle);
	float s = sin(angle);
	return mat2(c, -s, s, c);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = (2 * fragCoord.xy - iResolution.xy) / max(iResolution.x, iResolution.y);

	vec4 result = vec4(0,0,0,1);

	float t = 1.;
	float offset = -5. * iTime;
	float base = 80. * length(uv);

	float d = sin(-iTime * 2 + 15. * length(uv));
	d *= d * d;

	mat2 rot = rotate(5. * length(uv));
	uv = abs(rot * uv);

	for (int p = 0; p < 3; p++)
	{
		result[p] = sin(offset + t * base) - cos(20. * uv.x) - cos(20. * uv.y);
		t += 0.05;
	}

	result.xyz *= result.xyz;
	result.xyz = 1. - result.xyz;

	fragColor = result * d;
}

// https://www.shadertoy.com/view/Xt2BDG
