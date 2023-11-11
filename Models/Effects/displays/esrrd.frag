#version 120

uniform sampler2D BaseTex;
uniform sampler2D DirtTex;

uniform int display_enabled;
uniform float parameter_a;
uniform float parameter_b;
uniform float parameter_c;
uniform float parameter_d;

void main()
{
	vec3 texel = vec3(0.0, 0.0, 0.0);
	vec3 dirt = texture2D(DirtTex, gl_TexCoord[0].xy).rgb;
	vec2 position = vec2(gl_TexCoord[0].x, gl_TexCoord[0].y + 
											-parameter_a*gl_TexCoord[0].x*gl_TexCoord[0].x*gl_TexCoord[0].x +
											-parameter_b*gl_TexCoord[0].x*gl_TexCoord[0].x + 
											-parameter_c*gl_TexCoord[0].x + 
											-parameter_d);

	if(display_enabled > 0)
	{
		texel.g = texture2D(BaseTex, gl_TexCoord[0].xy).g;
		texel.g = max(texel.g, texture2D(BaseTex, position).b);
	}
	texel = mix(texel, dirt, 0.05);
	gl_FragColor = vec4(texel, 1.0);
}
