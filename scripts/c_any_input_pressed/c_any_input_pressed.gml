function c_any_input_pressed()
{
    if (keyboard_check_pressed(vk_anykey)) return true;

    var _buttons = [gp_face1, gp_face2, gp_face3, gp_face4,
                    gp_shoulderl, gp_shoulderr, gp_shoulderlb, gp_shoulderrb,
                    gp_select, gp_start, gp_stickl, gp_stickr,
                    gp_padu, gp_padd, gp_padl, gp_padr];

    for (var _p = 0; _p < 4; _p++)
    {
        if (!gamepad_is_connected(_p)) continue;

        for (var _i = 0; _i < array_length(_buttons); _i++)
        {
            if (gamepad_button_check_pressed(_p, _buttons[_i])) return true;
        }
    }
    return false;
}