// Code by Flopine
// Thanks to wsmind and Leon for teaching me :)


#define PI 3.14

mat2 rot (float angle)
{
    float c = cos(angle);
    float s = sin(angle);
    return mat2 (c,-s,s,c);
}

vec2 moda (vec2 p, float per)
{
    float angle = atan(p.y,p.x);
    float l = length(p);
    angle = mod(angle-per/2., per)-per/2.;
    return vec2(cos(angle),sin(angle))*l;
}


float cylY (vec3 p, float r)
{
  return length(p.xy)-r;  
}

float SDF (vec3 p)
{
    float per = 0.7;
    
    p.x = abs(p.x);   
    p.xy *= rot(p.z+iTime);
    p.xy = moda(p.xy, (sin(iTime)+2.)*PI/4.);
    
    p.yz = mod(p.yz-per/2.,per)-per/2.;           
    p.yz *= rot(p.x+iTime);

    p.x -= .7;
	
    return cylY(p,0.2);
    
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = 2.*(fragCoord.xy / iResolution.xy)-1.;
    uv.x *= iResolution.x/iResolution.y;
    
    vec3 pos = vec3(0.001,0.001,iTime*0.8);
    vec3 dir = normalize(vec3(uv, 1.));
    
    float shad = 0.;
    
    
    for (int i=0; i<100; i++)
    {
        float d = SDF(pos);
        if (d<0.01)
        {
            shad = float(i)/60.;
            break;
        }
        else shad = 0.8; 
        pos += d*0.2*dir;
    }
    
    vec3 hue = vec3(abs(pos.y)*3.,1.,.5);
	fragColor = vec4(vec3(shad)/hue,1.0);
}
