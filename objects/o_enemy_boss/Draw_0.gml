/// @description - HealthBar y laser

draw_self()

if (state == "fight")
{
    var bar_w      = 32;
    var bar_top    = 100;
    var bar_bottom = room_height - 100;
    var bar_h      = bar_bottom - bar_top;
    var bar_x      = room_width - 60;   // pegada al borde derecho

    var fill_h = (hp / hpMax) * bar_h;

    // fondo: representa la vida ya perdida
    draw_set_color(c_dkgray);
    draw_rectangle(bar_x, bar_top, bar_x + bar_w, bar_bottom, false);

    // vida actual: se llena desde abajo, el borde superior "baja" al recibir daño
    draw_set_color(c_red);
    draw_rectangle(bar_x, bar_bottom - fill_h, bar_x + bar_w, bar_bottom, false);

    draw_set_color(c_white);
    draw_rectangle(bar_x, bar_top, bar_x + bar_w, bar_bottom, true); // marco
    draw_set_color(c_white);
}


if (laser_active)
{
    if (laser_state == "aiming")
    {
        var dash = 14, gap = 10, total = dash + gap;
        var segs = laser_aim_length / total;

        draw_set_color(c_red);
        draw_set_alpha((laser_timer mod 20) < 10 ? 0.35 : 0.85);

        for (var i = 0; i < segs; i++)
        {
            var d0 = i * total;
            var d1 = d0 + dash;
            draw_line_width(
                x + lengthdir_x(d0, laser_direction), y + lengthdir_y(d0, laser_direction),
                x + lengthdir_x(d1, laser_direction), y + lengthdir_y(d1, laser_direction), 2);
        }
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
    else if (laser_state == "firing")
    {
        draw_set_color(c_blue);
        draw_line_width(x, y,
            x + lengthdir_x(laser_beam_length, laser_direction),
            y + lengthdir_y(laser_beam_length, laser_direction), 6);
        draw_set_color(c_white);
    }
}