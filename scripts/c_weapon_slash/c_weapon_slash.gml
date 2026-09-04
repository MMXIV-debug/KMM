function c_weapon_slash()
{
    var offset = 60 * facing;
    var atk = instance_create_layer(x + offset, y, "att", o_standard_slash);
    atk.facing = facing;
    atk.image_xscale = facing;
}