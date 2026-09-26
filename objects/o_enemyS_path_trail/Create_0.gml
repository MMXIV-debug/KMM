origin_x = 0;
origin_y = 0;
end_x = 0;
end_y = 0;

life_time  = 3 * room_speed;  // sigue dañando 3 segundos después de que el enemigo se fue
life_timer = life_time;

trail_tick_interval = 15;     // chequea daño cada 0.25s
trail_tick_timer    = 0;
trail_dmg = 8;