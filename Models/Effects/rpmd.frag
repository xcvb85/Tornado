#version 120

uniform sampler2D BaseTex;
uniform sampler2D DirtTex;

uniform int display_enabled;

void main()
{
	vec3 bg = vec3(1.0, 0.8, 0.0);
	vec3 texel = texture2D(BaseTex, gl_TexCoord[0].xy).rgb;
	//vec3 dirt = texture2D(DirtTex, gl_TexCoord[0].xy).rgb;

	vec2 position = vec2(2.0 * gl_TexCoord[0].xy - 1.0);
	bg *= 1.0 - length(position);

	float alpha = min(texel.r, texel.g);
	alpha = min(alpha, texel.b);

	//texel = mix(texel, dirt, 0.5);
	texel = mix(texel, bg, alpha);

	gl_FragColor = vec4(texel, 1.0);
}
