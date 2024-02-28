#version 120

uniform sampler2D BaseTex;
uniform sampler2D DirtTex;

uniform int display_enabled;
uniform float rotation_deg;

void main()
{
	vec3 texel = vec3(0.0, 0.0, 0.0);
	float dirt = 0.3*texture2D(DirtTex, gl_TexCoord[0].xy).a;
	vec2 position = 0.75*vec2(2.0 * gl_TexCoord[0].xy - 1.0);

	if(		display_enabled > 0 && // display enabled
			length(position) < 1.0 && // within visible area
			length(position) > 0.05 && // black dot
			abs(position.x) > 0.01) // black line
	{
		vec3 bg_lightning = vec3(1.0, 0.8, 0.0) * (1.0 - length(position));
		float rotation_rad = (-rotation_deg*3.14159)/180.0;

		// rotation
		float x = (position.x * cos(rotation_rad)) - (position.y * sin(rotation_rad));
		position.y = (position.x * sin(rotation_rad)) + (position.y * cos(rotation_rad));
		position.x = x;
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
