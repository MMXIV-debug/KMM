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


// Barra de carga del Parry (RoomS)
if (room == RoomS)
{
    var bar_w = 220, bar_h = 18;
    var bar_x = start_x;
    var bar_y = start_y + heart_size + 20;
    var fill_w = bar_w * (parry_charge / parry_charge_max);

    draw_set_color(c_black);
    draw_rectangle(bar_x - 2, bar_y - 2, bar_x + bar_w + 2, bar_y + bar_h + 2, false);

    draw_set_color(make_color_rgb(80, 20, 60));
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

    draw_set_color(charged_shot_ready ? make_color_rgb(255, 215, 90) : make_color_rgb(255, 90, 180));
    draw_rectangle(bar_x, bar_y, bar_x + fill_w, bar_y + bar_h, false);

    draw_set_color(c_white);
    draw_text(bar_x, bar_y + bar_h + 4,
        charged_shot_ready ? "¡DISPARO CARGADO LISTO! (J)" : string(round(parry_charge)) + "/" + string(parry_charge_max));
}
