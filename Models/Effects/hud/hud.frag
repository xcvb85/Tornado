#version 120

uniform sampler2D BaseTex;

uniform float view_x;
uniform float view_y;

void main()
{
        vec4 texel = vec4(0.0, 0.0, 0.0, 1.0);
        vec2 position = gl_TexCoord[0].xy;
        position.x += -7.0*view_x;
        position.y += -10.0*(view_y+0.18);
        texel = texture2D(BaseTex, position).rgba;

        gl_FragColor = texel;
}
