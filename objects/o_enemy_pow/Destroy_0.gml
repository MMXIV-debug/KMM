// Inherit the parent event
event_inherited();

if (hp <= 0)
{
    var tipo = irandom_range(1, 100);

    if (tipo <= 45)
    {
        instance_create_layer(x, y, "Instances", o_power_plus);
    } 
    else if (tipo <= 70) 
    {
        instance_create_layer(x, y, "Instances", o_power_homing);
    } 
    else if (tipo <= 82)
    {
        instance_create_layer(x, y, "Instances", o_power_overdrive);
    }
    // tipo > 82 (18%): no suelta nada
}