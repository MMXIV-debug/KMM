if (mouse_check_button_pressed(mb_left))
{
    var mx = mouse_x;
    var my = mouse_y;

    if (mx > btn_start_x1 && mx < btn_start_x2 && my > btn_start_y1 && my < btn_start_y2)
    {
        room_goto(RoomK);
    }
    else if (mx > btn_quit_x1 && mx < btn_quit_x2 && my > btn_quit_y1 && my < btn_quit_y2)
    {
        game_end();
    }
}