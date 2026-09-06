// Inherit the parent event
event_inherited();

if (hp <= 0 && irandom_range(1, 100) <= drop_chance)
{
    instance_create_layer(x, y, "pow", o_power_homing);
}