// Indicador de vida (corazones) ----------------------------
var hp_per_heart = max_hp / total_hearts; // con 100 hp y 6 corazones ≈ 16.67 por corazón
var heart_size = 32;
var heart_spacing = 25;
var start_x = 20;
var start_y = 20;

for (var i = 0; i < total_hearts; i++)
{
    var heart_hp = hp - (i * hp_per_heart);
    var heart_x = start_x + i * (heart_size + heart_spacing);

    if (heart_hp >= hp_per_heart)
    {
        draw_sprite(s_heart_full, 0, heart_x, start_y);
    }
    else if (heart_hp > 0)
    {
        draw_sprite(s_heart_half, 0, heart_x, start_y);
    }
    else
    {
        draw_sprite(s_heart_empty, 0, heart_x, start_y);
    }
}

// Indicador de muerte y dibujo en pantalla ----------------------------
if (is_dead)
{
    // Oscurecer pantalla
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1); // importante: resetear el alpha para que el texto no salga transparente

    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(gui_w/2, gui_h/2 - 40, "Moriste");

    var btn_x1 = gui_w/2 - 80;
    var btn_y1 = gui_h/2;
    var btn_x2 = gui_w/2 + 80;
    var btn_y2 = gui_h/2 + 40;

    draw_set_color(c_gray);
    draw_rectangle(btn_x1, btn_y1, btn_x2, btn_y2, false);
    draw_set_color(c_white);
    draw_text((btn_x1 + btn_x2)/2, (btn_y1 + btn_y2)/2, "Reiniciar");

    if (mouse_check_button_pressed(mb_left))
    {
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);

        if (mx > btn_x1 && mx < btn_x2 && my > btn_y1 && my < btn_y2)
        {
            game_restart();
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}