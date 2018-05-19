#define TWO_PI 6.28318530718
#define e  2.71828


float DrawRectangle(in vec2 pos, in vec2 dimensions , in vec2 coord){
	vec2 d = abs(coord - pos) - dimensions;
	return float(max(d.x,d.y)<0.);
}

vec4 PalletToRGB(vec3 col01, vec3 col02, vec3 col03, vec3 col04, vec3 colorToConvert){
	vec3 toReturn = col04;
	toReturn = mix(toReturn, col01, colorToConvert.x);
	toReturn = mix(toReturn, col02, colorToConvert.y);
	toReturn = mix(toReturn, col03, colorToConvert.z);

	return vec4(toReturn, 1.0);
}

// PATTERNS FUNCTIONS

void Patter01(inout vec3 color, in vec3 PatternColor01, in vec3 PatternColor02, in float yPos, in vec2 coord, in float size){

	float lineWidthUnit = size/ (7.0);
	vec3 colorToAdd = PatternColor01;
	float lineWidthUnitXStretched = lineWidthUnit / (lineWidthUnit *12.0);

	float distanceToCenter= abs( coord.y - yPos) / (size/2.0);



	float repeatingXCoordinat01 = fract(coord.x / (lineWidthUnit *6.0) );

	float facingUp = DrawRectangle( vec2(0.25, yPos  - lineWidthUnit),
			vec2(lineWidthUnitXStretched, lineWidthUnit*2.5), vec2(repeatingXCoordinat01, coord.y)) +
		DrawRectangle( vec2(0.25, yPos  + lineWidthUnit),
				vec2(lineWidthUnitXStretched*3.5, lineWidthUnit*0.5), vec2(repeatingXCoordinat01, coord.y));

	float facingDowm = DrawRectangle( vec2(0.75, yPos  + lineWidthUnit),
			vec2(lineWidthUnitXStretched, lineWidthUnit*2.5), vec2(repeatingXCoordinat01, coord.y)) +
		DrawRectangle( vec2(0.75, yPos  - lineWidthUnit),
				vec2(lineWidthUnitXStretched*3.5, lineWidthUnit*0.5), vec2(repeatingXCoordinat01, coord.y));

	float borders = DrawRectangle( vec2(0.5, yPos  - 3.0 * lineWidthUnit),
			vec2(lineWidthUnitXStretched*8.0, lineWidthUnit * 0.5), vec2(repeatingXCoordinat01, coord.y))
		+  DrawRectangle( vec2(0.5, yPos  + 3.0 * lineWidthUnit),
				vec2(lineWidthUnitXStretched*8.0, lineWidthUnit * 0.5), vec2(repeatingXCoordinat01, coord.y));


	float repeatingPattern =   facingUp + facingDowm + borders;
	repeatingPattern = clamp(repeatingPattern, 0.0, 1.0);

	colorToAdd = mix(PatternColor02, colorToAdd, 1.0 - repeatingPattern);


	float upDownEdges = (1.0 - step( lineWidthUnit * 3.5 + yPos, coord.y) )*
		(step( -lineWidthUnit * 3.5 + yPos, coord.y));


	colorToAdd = mix(colorToAdd, colorToAdd * 0.6, pow( distanceToCenter, 1.4) /1.0);

	color = mix(colorToAdd, color, 1.0 - upDownEdges);


}

void Patter02(inout vec3 color, in vec3 PatternColor01, in vec3 PatternColor02, in float yPos, in vec2 coord, in float size){

	float lineWidthUnit = size/ (7.0);
	vec3 colorToAdd = PatternColor01;
	float lineWidthUnitXStretched = lineWidthUnit / (lineWidthUnit *12.0);
	float distanceToCenter= abs( coord.y - yPos) / (size/2.0);


	float repeatingXCoordinat01 = fract(coord.x / (lineWidthUnit *6.0) );

	float facingUp = DrawRectangle( vec2(0.25, yPos  - lineWidthUnit),
			vec2(lineWidthUnitXStretched, lineWidthUnit*2.5), vec2(repeatingXCoordinat01, coord.y)) +
		DrawRectangle( vec2(0.4167, yPos  + lineWidthUnit),
				vec2(lineWidthUnitXStretched*3.0, lineWidthUnit*0.5), vec2(repeatingXCoordinat01, coord.y));

	float facingDowm = DrawRectangle( vec2(0.9167, yPos  + lineWidthUnit),
			vec2(lineWidthUnitXStretched, lineWidthUnit*2.5), vec2(repeatingXCoordinat01, coord.y)) +
		DrawRectangle( vec2(0.75, yPos  - lineWidthUnit),
				vec2(lineWidthUnitXStretched*3.5, lineWidthUnit*0.5), vec2(repeatingXCoordinat01, coord.y));

	float borders = DrawRectangle( vec2(0.5, yPos  - 3.0 * lineWidthUnit),
			vec2(lineWidthUnitXStretched*8.0, lineWidthUnit * 0.5), vec2(repeatingXCoordinat01, coord.y))
		+  DrawRectangle( vec2(0.5, yPos  + 3.0 * lineWidthUnit),
				vec2(lineWidthUnitXStretched*8.0, lineWidthUnit * 0.5), vec2(repeatingXCoordinat01, coord.y));


	float repeatingPattern =   facingUp + facingDowm + borders;
	repeatingPattern = clamp(repeatingPattern, 0.0, 1.0);

	colorToAdd = mix(PatternColor02, colorToAdd, 1.0 - repeatingPattern);


	float upDownEdges = (1.0 - step( lineWidthUnit * 3.5 + yPos, coord.y) )*
		(step( -lineWidthUnit * 3.5 + yPos, coord.y));
	colorToAdd = mix(colorToAdd, colorToAdd * 0.7, pow( distanceToCenter, 1.4) /1.0);

	color = mix(colorToAdd, color, 1.0 - upDownEdges);
}

void Patter03(inout vec3 color, in vec3 PatternColor01, in vec3 PatternColor02, in float yPos, in vec2 coord, in float size){
	float lineWidthUnit = size/ (9.0);
	vec3 colorToAdd = PatternColor01;
	float lineWidthUnitXStretched = lineWidthUnit / (lineWidthUnit *8.0);
	float xUnit = 1.0/8.0;
	float distanceToCenter= abs( coord.y - yPos) / (size/2.0);


	float repeatingXCoordinat01 = fract(coord.x / (lineWidthUnit *8.0) );

	float facingUp = DrawRectangle( vec2(xUnit * 1.5, yPos  - lineWidthUnit * 0.5),
			vec2(lineWidthUnitXStretched *0.5, lineWidthUnit*3.0), vec2(repeatingXCoordinat01, coord.y)) +
		DrawRectangle( vec2(3.5*xUnit, yPos  + lineWidthUnit * 2.0),
				vec2(lineWidthUnitXStretched*2.5, lineWidthUnit*0.5), vec2(repeatingXCoordinat01, coord.y)) +
		DrawRectangle( vec2(3.5*xUnit, yPos  - lineWidthUnit ),
				vec2(lineWidthUnitXStretched*0.5, lineWidthUnit*1.5), vec2(repeatingXCoordinat01, coord.y)) ;

	float facingDowm = DrawRectangle( vec2(1.0 - xUnit*0.5, yPos  + lineWidthUnit * 0.5),
			vec2(lineWidthUnitXStretched * 0.5, lineWidthUnit * 3.0), vec2(repeatingXCoordinat01, coord.y)) +
		DrawRectangle( vec2(5.5 * xUnit, yPos  - lineWidthUnit  * 2.0),
				vec2(lineWidthUnitXStretched*2.5, lineWidthUnit*0.5), vec2(repeatingXCoordinat01, coord.y)) +
		DrawRectangle( vec2(5.5*xUnit, yPos  + lineWidthUnit ),
				vec2(lineWidthUnitXStretched*0.5, lineWidthUnit*1.5), vec2(repeatingXCoordinat01, coord.y));

	float borders = DrawRectangle( vec2(0.5, yPos  - 4.0 * lineWidthUnit),
			vec2(lineWidthUnitXStretched*8.0, lineWidthUnit * 0.5), vec2(repeatingXCoordinat01, coord.y))
		+  DrawRectangle( vec2(0.5, yPos  + 4.0 * lineWidthUnit),
				vec2(lineWidthUnitXStretched*8.0, lineWidthUnit * 0.5), vec2(repeatingXCoordinat01, coord.y));


	float repeatingPattern =   facingUp + facingDowm + borders;
	repeatingPattern = clamp(repeatingPattern, 0.0, 1.0);

	colorToAdd = mix(PatternColor02, colorToAdd, 1.0 - repeatingPattern);


	float upDownEdges = (1.0 - step( lineWidthUnit * 4.5 + yPos, coord.y) )*
		(step( -lineWidthUnit * 4.5 + yPos, coord.y));
	colorToAdd = mix(colorToAdd, colorToAdd * 0.7, pow( distanceToCenter, 1.4) /1.0);
	color = mix(colorToAdd, color, 1.0 - upDownEdges);
}

void Patter04(inout vec3 color, in vec3 PatternColor01, in vec3 PatternColor02, in float yPos, in vec2 coord, in float size){
	float lineWidthUnit = size/ (8.0);
	vec3 colorToAdd = PatternColor01;
	float lineWidthUnitXStretched = lineWidthUnit / (lineWidthUnit *8.0);
	float xUnit = 1.0/8.0;
	float distanceToCenter= abs( coord.y - yPos) / (size/2.0);
	vec2 spiralCenter = vec2( 0.66, yPos - lineWidthUnit * 0.5 );

	vec2 spiralCenterPrevieus = vec2( -0.44, yPos - lineWidthUnit * 0.5 );
	float repeatingXCoordinat01 = fract(coord.x / (lineWidthUnit *8.0) );

	// Map to 0 to 1

	vec2 pixelToCenter = vec2(repeatingXCoordinat01, coord.y) - spiralCenter;
	vec2 pixelToCenterTwo = vec2(repeatingXCoordinat01, coord.y) - spiralCenterPrevieus;



	float angle = atan(pixelToCenter.y , (pixelToCenter.x/8.0)) ;
	float angle2 = atan(- pixelToCenter.y , -(pixelToCenter.x/ 8.0)) ;
	float angle3 = atan(- pixelToCenterTwo.y , -(pixelToCenterTwo.x/ 8.0)) ;

	float firstSpiralAlpha = (((angle ) /TWO_PI)+0.5);
	float secondSpiralAlpha =  (((-angle ) /TWO_PI)+0.5);
	float thirdSpiralAngel = (((angle2 ) /TWO_PI)+0.5);
	float forthSpiralAngel = (((-angle3 ) /TWO_PI)+0.5);

	float distanceToThePixelFromCenterSpiral01 = length(vec2(pixelToCenter.x*0.6, pixelToCenter.y * 4.0));

	float a = 0.28 * size;
	float b = 38.2 * size;

	float spiralOne= (step( (a * 1.5  * pow(e, firstSpiralAlpha* atan(b ) )) , (distanceToThePixelFromCenterSpiral01)) );
	float spiralTwo =  step( (a *1.0* pow(e, secondSpiralAlpha* atan(b /1.0) )) , (distanceToThePixelFromCenterSpiral01));
	float spiralThree =  step( (a *0.135* pow(e, thirdSpiralAngel* 3.0 *atan(b /1.8) )) , (distanceToThePixelFromCenterSpiral01));
	float cutOutEdge = (1.0 - step(0.078, repeatingXCoordinat01))  * (1.0 - step( (repeatingXCoordinat01 * 0.55 ) -0.047+ yPos, coord.y));

	float blendingFactor = (step(0.078, repeatingXCoordinat01) * (((1.0 -spiralOne) * spiralTwo) +( spiralThree  * step(0.5, thirdSpiralAngel)))) + cutOutEdge;


	colorToAdd = mix(PatternColor02, PatternColor01,clamp( 1.0 - blendingFactor, 0.0, 1.0));


	float upDownEdges = (1.0 - step( lineWidthUnit * 4.5 + yPos, coord.y) )*
		(step( -lineWidthUnit * 4.5 + yPos, coord.y));
	colorToAdd = mix(colorToAdd, colorToAdd * 0.7, pow( distanceToCenter, 1.4) /1.0);
	color = mix(colorToAdd, color, 1.0 - upDownEdges);


}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	// Settomg up the UV coordinates
	vec2 uv = fragCoord.xy / iResolution.y;

	vec3 backGround = vec3(0.0,0.0,0.1);
	vec3 color01 = vec3(0.758 + sin(iTime * 0.8) / 4.0, + cos((iTime + TWO_PI /2.0) * 0.8), 0.031);
	vec3 color02 = vec3(1.0, 0.6 + cos(iTime * 0.8), 0.1);
	vec3 color03 = vec3(1.0, 0.9, 0.9);

	float highlightRunning = 1.0 - smoothstep(0.01, 0.5, abs(
				(fract(iTime / 4.0  ) * iResolution.x * 2.0/ iResolution.y) -0.5 - uv.x ));
	vec3 colorToReturn = vec3(0.4, 0.8, 0.4);

	float distanceToCenter = distance(uv, vec2(((iResolution.x/  iResolution.y))/2.0 ,0.5));


	Patter01(colorToReturn, vec3(0.99, 0.0141, 0.2), vec3(0.1, 0.9, uv.x/5.0),0.9, vec2(uv.x + iTime * 0.2, uv.y), 0.2);
	Patter02(colorToReturn, vec3(abs(2.0 * fract(iTime / 5.0) - 1.0 ) , abs(2.0 * fract(iTime / 5.0) - 1.0 )*1.2, 0.0312 ),vec3(0.7-  abs(2.0 * fract(iTime / 5.0) - 1.0 )*0.5, 0.16, uv.x/5.0), 0.68,vec2(uv.x - iTime * 0.2, uv.y), 0.2);
	Patter03(colorToReturn, vec3(0.91325 , 0.3213 + highlightRunning, 0.1  ), vec3( highlightRunning, 0.321, uv.x/7.0), 0.40, vec2(uv.x + iTime * 0.3, uv.y), 0.31);

	Patter04(colorToReturn, vec3(0.11325 , 0.9213 + highlightRunning, 0.1  ), vec3(0.1, 0.121, uv.x/7.0), 0.1, vec2(uv.x - iTime * 0.1, uv.y), 0.2);


	fragColor =  PalletToRGB(color01, color02, color03, backGround, colorToReturn);

	fragColor *= (1.0 -smoothstep(0.3, 1.2, distanceToCenter));
}

// https://www.shadertoy.com/view/4l2fWR
