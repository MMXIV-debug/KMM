/// @description Boom
state = "boom";

if (instance_exists(o_player))
{
    var d = point_distance(x, y, o_player.x, o_player.y);
    if (d <= explode_radius)
    {
        with (o_player) { c_player_take_damage(other.dmg); }
    }
}

alarm[1] = 15; // dura el aviso visual