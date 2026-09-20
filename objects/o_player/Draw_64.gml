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
