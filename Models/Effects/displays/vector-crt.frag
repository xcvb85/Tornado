#version 120

uniform float osg_SimulationTime;

uniform sampler2D BaseTex;
uniform sampler2D DirtTex;

uniform int display_power;
uniform float display_bright;
uniform float display_zoom;

float DISTORTION = 0.03;
float THRESHOLD = 0.1;

vec2 TextureSize = vec2(512, 512);

vec3 bloomTexture2D(sampler2D texture, vec2 position)
{
	int size = 2;

	vec3 texel = vec3(0, 0, 0);

	for(int x = -size; x <= size; x++)
	{
		for(int y = -size; y <= size; y++)
		{
			texel += texture2D(texture, position + vec2(x/TextureSize.x, y/TextureSize.y)).rgb;
		}
	}
	return texel/pow((2*size)+1, 2);
}

vec2 distort(vec2 position, float zoom)
{
	position = vec2(2.0 * position - 1.0);
	position *= zoom;
	position = position /(1.0 - DISTORTION * length(position));
	position =(position + 1.0) * 0.5;
	return position;
}

vec3 rdrNoise(vec2 position, vec3 texel)
{
	float offset = 0.01*sin(10*position.y+100.0*osg_SimulationTime)*cos(100*position.y-100.0*osg_SimulationTime);
	texel.g += texture2D(BaseTex, vec2(position.x+offset, position.y)).b;
	texel.g = clamp(texel.g, 0.0, 1.0);
	return texel;
}

vec3 backlight(vec3 color)
{
	if(color.r < THRESHOLD && color.g < THRESHOLD && color.b < THRESHOLD) {
		color = vec3(0, THRESHOLD, 0);
	}
	return color;
}

vec3 flickering(vec2 position, vec3 texel)
{
	texel *= 0.7+0.3*(1-mod(10.0*osg_SimulationTime+position.y, 1.0));
	return texel;
}

void main()
{
	vec3 texel = vec3(0.0, 0.0, 0.0);
	float dirt = 0.3*texture2D(DirtTex, gl_TexCoord[0].xy).a;

	if(display_power > 0) {
		vec2 position = gl_TexCoord[0].xy;

		position = distort(position, display_zoom);

		if(position.x > 0.0 && position.y > 0.0 && position.x < 1.0 && position.y < 1.0) {
			vec3 orgtexel = texture2D(BaseTex, position).rgb;
			orgtexel.r = 0.5*orgtexel.g;
			orgtexel.b = 0.5*orgtexel.g;

			texel = bloomTexture2D(BaseTex, position).rgb;
			//texel = rdrNoise(position, texel);
			texel.b = 0.0;
			texel = max(texel, orgtexel);
			//texel = flickering(position, texel);
			texel = backlight(texel);
		}
	}
	texel = max(display_bright*texel, vec3(dirt));
	gl_FragColor = vec4(texel, 1.0);
}
