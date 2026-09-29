if (state == "flying")
{
    dist_traveled += speed;

    if (dist_traveled >= travel_dist)
    {
        speed = 0;
        state = "boom";

        if (instance_exists(o_player))
        {
            var d = point_distance(x, y, o_player.x, o_player.y);
            if (d <= explode_radius)
            {
				var damage = dmg;
                with (o_player) { c_player_take_damage(damage); }
            }
        }

        alarm[0] = 20; // dura el aviso visual antes de desaparecer
    }
}