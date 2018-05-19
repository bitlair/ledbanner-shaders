#pragma map iChannel0=video:/home/polyfloyd/Documents/Projects/Text Smilies/Lenny Face Challenge/LENNY FACE TAG Shubble lO82ggwCnAQ.webm

float zigzag(float n) {
    // 1.33 should be 1.0 for real zigzag
    return abs(mod(n,2.0)-1.33);
}
void mainImage( out vec4 O, in vec2 uv ) {
	uv /= iResolution.y;
    uv.x -= .5*iResolution.x/iResolution.y;
    uv.y -= .5;
    float l = length(uv) + .2 * sin(iTime * .21);
    float a = atan(uv.y, uv.x)/3.14159 + sin(l + iTime * .1);
    uv.x = zigzag(a * 3.);
    uv.y = zigzag(l * 5.);

    // darkening radial waves
    float bri = (1. + .5 * sin(l * 5. - iTime));
    vec4 c = texture(iChannel0, uv) * bri;

    // colorize
    c *= vec4(10., 17., 1.8, 1.);
    c = .5+.5*sin(c);
	O = c;
}
