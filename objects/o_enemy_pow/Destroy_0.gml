// Inherit the parent event
event_inherited();

var tipo = irandom_range(1, 100);

if (tipo <= 40)
{
    instance_create_layer(x, y, "Instances", o_power_plus);
} 
else if (tipo <= 70) 
{
    instance_create_layer(x, y, "Instances", o_power_overdrive);
} 