

if (!boss_spawned)
{
    var remaining = max(0, boss_time - game_timer);
    var secs = remaining div room_speed;

    var gui_w = display_get_gui_width();

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(gui_w / 2, 20, "Jefe en: " + string(secs) + "s");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}