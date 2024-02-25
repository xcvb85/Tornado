#version 120

uniform sampler2D BaseTex;
uniform sampler2D DirtTex;

uniform int display_enabled;

void main()
{
	vec3 texel = vec3(0.0, 0.0, 0.0);
	float dirt = 0.3*texture2D(DirtTex, gl_TexCoord[0].xy).a;
	vec2 position = vec2(2.0 * gl_TexCoord[0].xy - 1.0);

	if(		display_enabled > 0) // display enabled
	{
		vec3 bg_lightning = vec3(1.0, 0.8, 0.0) * (1.0 - length(position));

		// rotation
		position = (position + 1.0) * 0.5;

		// get image texture
		texel = texture2D(BaseTex, position).rgb;

		// gamma to alpha
		float alpha = min(texel.r, texel.g);
		alpha = min(alpha, texel.b);

		// add background lightning and dirt
		texel = mix(texel, bg_lightning, 0.6*alpha);
	}
	texel = max(texel, vec3(dirt));
	gl_FragColor = vec4(texel, 1.0);
}
