// Aura de Parry (RoomS)
if (room == RoomS && (parry_active || parry_cooldown_timer > 0))
{
    var _pulse  = 0.5 + 0.5 * sin(current_time / 90);
    var _radius = 46 + _pulse * 6;

    // Activo = magenta bien saturado; en cooldown = un rosa tenue de "todavía no"
    var _col   = parry_active ? make_color_rgb(255, 70, 180) : make_color_rgb(255, 150, 210);
    var _alpha = parry_active ? (0.55 + _pulse * 0.25) : 0.12;

    gpu_set_blendmode(bm_add);
    draw_set_alpha(_alpha);
    draw_set_color(_col);
    draw_circle(x, y, _radius, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
}

if (invuln_timer > 0 && (invuln_timer div 4) % 2 == 0)
{
    gpu_set_blendmode(bm_add);
    draw_self();
    gpu_set_blendmode(bm_normal);
}
else
{
    draw_self();
}