if (hp <= 0)
{
    instance_destroy();
    exit;
}

if (dmg_cooldown > 0) dmg_cooldown--;

var _margin = 80;
if (x < -_margin || x > room_width + _margin || y < -_margin || y > room_height + _margin)
{
    instance_destroy();
}

// Rastro: si el jugador toca la línea que ya recorrió, daño
trail_tick_timer--;
if (trail_tick_timer <= 0)
{
    trail_tick_timer = trail_tick_interval;
    if (collision_line(origin_x, origin_y, x, y, o_player, false, true))
    {
        with (o_player) { c_player_take_damage(other.trail_dmg); }
    }
}

// Dispara teledirigidas mientras avanza
if (canShoot && instance_exists(o_player))
{
    canShoot = false;
    alarm[0] = reloadSpeed;

    var _b = instance_create_layer(x, y, "att", o_enemy_shoot_hom);
    _b.direction = point_direction(x, y, o_player.x, o_player.y);
    _b.speed     = 8;
}