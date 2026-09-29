if (room == RoomVEnd)
{
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);

    draw_text(_gw / 2, _gh - 110, "Muertes: " + string(global.total_deaths));

    if (song_done)
    {
        draw_text(_gw / 2, _gh - 60, "Presiona cualquier boton para volver al menu");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}