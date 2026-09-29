speed = 6;
dmg = 30;
travel_dist = 450;
// Recorre la distancia hasta el player (queda a ~60px de donde estaba al lanzarse)
if (instance_exists(o_player))
{
    travel_dist = max(450, point_distance(x, y, o_player.x, o_player.y) - 60);
}
dist_traveled = 0;
explode_radius = 120;

state = "flying"; // flying -> boom