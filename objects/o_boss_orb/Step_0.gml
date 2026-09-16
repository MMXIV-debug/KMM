// Avanzar en la direccion asignada
dist_traveled += speed;

// Explotar al llegar a la distancia limite
if (dist_traveled >= travel_dist)
{
    // Danar al jugador si esta en el radio
    if (instance_exists(o_player))
    {
        var d = point_distance(x, y, o_player.x, o_player.y);
        if (d <= explode_radius)
        {
            with (o_player)
            {
                c_player_take_damage(other.dmg);
            }
        }
    }
    instance_destroy();
}
