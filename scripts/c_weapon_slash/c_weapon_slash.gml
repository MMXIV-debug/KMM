function c_weapon_slash()
{
    sprite_index = s_att_sword;
    image_index = 0;
    image_speed = 1;
    is_attacking = true;

    var offset = 80 * facing;
    var atk = instance_create_layer(x + offset, y, "att", o_standard_slash);
    atk.facing = facing;
    atk.image_xscale = facing;
}