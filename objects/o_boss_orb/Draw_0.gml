// Dibujar la esfera: circulo morado que pulsa
var pulse = sin(current_time / 80) * 3;
draw_set_color(make_color_rgb(160, 0, 220));
draw_circle(x, y, 10 + pulse, false);
draw_set_color(make_color_rgb(220, 140, 255));
draw_circle(x, y, 5 + pulse * 0.5, false);
draw_set_color(c_white);
