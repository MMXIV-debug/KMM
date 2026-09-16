function c_weapon_hook()
{
    var atk = instance_create_layer(x, y, "att", o_hook_shot);
    atk.facing_dir = facing;
}