varying lowp vec2 TexCoord;

uniform sampler2D texture0;

void main(void) {
    gl_FragColor = texture2D(texture0, TexCoord);
}
