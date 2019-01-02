#pragma map font=image:./res/ascii.png

vec4 ascii(vec2 uv, int char) {
	vec2 charPos = vec2(char % 16, 15 - char / 16) / 16;
	return texture2D(font, (charPos + clamp(uv*.5+.5, 0, 1) / 16) * vec2(1, -1));
}

vec4 text(vec2 uv, float time) {
	int text[19]; // REFRESHING MEMORIES
	text[0] = 0x52; // R
	text[1] = 0x45; // E
	text[2] = 0x46; // F
	text[3] = 0x52; // R
	text[4] = 0x45; // E
	text[5] = 0x53; // S
	text[6] = 0x48; // H
	text[7] = 0x49; // I
	text[8] = 0x4E; // N
	text[9] = 0x47; // G
	text[10] = 0x20;
	text[11] = 0x4D; // M
	text[12] = 0x45; // E
	text[13] = 0x4D; // M
	text[14] = 0x4F; // O
	text[15] = 0x52; // R
	text[16] = 0x49; // I
	text[17] = 0x45; // E
	text[18] = 0x53; // S

	float numShown = 10;

	int edge = int(step(1, mod(time, 2)));
	int strStart = 11 * edge;
	int xoffset = 1 * edge;

	vec4 face = vec4(0);
	
	int strPos = int(floor((uv.x) * numShown - xoffset)) + strStart;
	if (uv.x > (xoffset / numShown) && strPos < text.length()) {
		int char = text[strPos];
		vec2 charUV = vec2(mod(uv.x * numShown, 1), uv.y) * 2 - 1;
		face = ascii(charUV * 0.8, char);
	}

	return vec4(0, 0, 0, face.r * 16);
}

vec3 wave(vec2 uv, float time) {
	vec3 a = vec3(0, 132, 176) / 255;
	vec3 b = vec3(0, 163, 86) / 255;
	return mix(a, b, sin(uv.x * 2 + time*4)*.5+.5);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 uv = fragCoord / iResolution.xy;

	fragColor.a = 1;
	fragColor.rgb = wave(uv, iTime * .5);

	vec4 textColor = text(uv, iTime * .5);
	fragColor.rgb = mix(fragColor.rgb, textColor.rgb, textColor.a);
}
