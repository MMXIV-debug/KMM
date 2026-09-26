global.kills_since_last_portal = 0;

game_timer = 0;
boss_spawned = false;
boss_time = 60 * room_speed; // 1 minuto exacto
last_deaths = 0;
death_penalty = 15 * room_speed; // 15 segundos extra por muerte

if (!variable_global_exists("pass"))
{
    global.pass = 0;
}

spawn_margin = 64;