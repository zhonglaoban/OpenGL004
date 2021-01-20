attribute vec3 a_Position;
attribute vec2 a_TexCoord;

varying lowp vec2 TexCoord;

void main(void) {
    gl_Position = vec4(a_Position, 1.0);
    TexCoord = a_TexCoord;
}
