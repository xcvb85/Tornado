#version 120

uniform float osg_SimulationTime;

uniform sampler2D BaseTex;
uniform sampler2D DirtTex;

uniform int display_enabled;

float DISTORTION = 0.03;

vec2 distort(vec2 position)
{
	position = vec2(2.0 * position - 1.0);
	position = position /(1.0 - DISTORTION * length(position));
	position =(position + 1.0) * 0.5;
	return position;
}

vec3 flickering(vec2 position, vec3 texel)
{
	texel *= 0.5+0.5*(1-mod(10.0*osg_SimulationTime+position.y, 1.0));
	return texel;
}

void main()
{
	vec3 texel = vec3(0.0, 0.0, 0.0);
	vec3 dirt = texture2D(DirtTex, gl_TexCoord[0].xy).rgb;

	if(display_enabled > 0) {
		vec2 position = distort(gl_TexCoord[0].xy);

		if(position.x > 0.0 && position.y > 0.0 && position.x < 1.0 && position.y < 1.0) {
			texel = texture2D(BaseTex, position).rgb;
			texel = flickering(position, texel);
		}
	}

	texel = mix(texel, dirt, 0.05);

	gl_FragColor = vec4(texel, 1.0);
}
