// variant of https://shadertoy.com/view/lt2Bzd

void mainImage(out vec4 O, in vec2 u) {
    vec2 U = u+u - iResolution.xy;
    float T = 6.2832;
    float l = length(U) / 30.;
    float L = ceil(l) * 6.;
    float a = atan(U.x,U.y) - iTime * 2.*(fract(1e4*sin(L))-.5);
    O = .6 + .4* cos( floor(fract(a/T)*L) + vec4(0,23,21,0) )
        - max(0., 9.* max( cos(T*l), cos(a*L) ) - 8. );
}

// https://www.shadertoy.com/view/XtjfDy
