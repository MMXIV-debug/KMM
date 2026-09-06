// Título (placeholder de texto, reemplazable por sprite después)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(room_width/2, room_height/2 - 150, title_text);

/* 
	Botón Start (placeholder rectángulo, reemplazable por sprite después)
	solo cambiar las líneas de draw_text/draw_rectangle por draw_sprite/draw_sprite_stretched
*/
draw_set_color(c_gray);
draw_rectangle(btn_start_x1, btn_start_y1, btn_start_x2, btn_start_y2, false); 
draw_set_color(c_white);
draw_text((btn_start_x1 + btn_start_x2)/2, (btn_start_y1 + btn_start_y2)/2, "JUGAR");

// Botón Quit
draw_set_color(c_gray);
draw_rectangle(btn_quit_x1, btn_quit_y1, btn_quit_x2, btn_quit_y2, false);
draw_set_color(c_white);
draw_text((btn_quit_x1 + btn_quit_x2)/2, (btn_quit_y1 + btn_quit_y2)/2, "SALIR");

draw_set_halign(fa_left);
draw_set_valign(fa_top);