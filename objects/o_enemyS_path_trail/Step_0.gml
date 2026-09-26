life_timer--;
if (life_timer <= 0)
{
    instance_destroy();
    exit;
}

trail_tick_timer--;
if (trail_tick_timer <= 0)
{
    trail_tick_timer = trail_tick_interval;
    if (collision_line(origin_x, origin_y, end_x, end_y, o_player, false, true))
    {
        with (o_player) { c_player_take_damage(other.trail_dmg); }
    }
}