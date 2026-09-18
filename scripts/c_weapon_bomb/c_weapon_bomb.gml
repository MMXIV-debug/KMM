function c_weapon_bomb()
{
    if (instance_exists(o_bomb))
    {
        // segundo apretón: detonar
        with (o_bomb)
        {
            c_bomb_explode(x, y, explode_radius, dmg);
            if (instance_exists(o_bomb))
				{
				    // segundo apretón: detonar
				    with (o_bomb)
				    {
				        c_bomb_explode(x, y, explode_radius, dmg);
				        state      = "boom";
				        boom_timer = boom_duration;
				    }
				}
        }
    }
    else
    {
        // primer apretón: lanzar
        var b = instance_create_layer(x + 40 * facing, y, "att", o_bomb);
        b.facing_dir = facing;
    }
}