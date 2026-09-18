
enemy_type  = o_enemy_fast;   // fallback si no se define spawn_types
spawn_types = [];             // si lo llenás desde la room, elige al azar

spawn_x        = 1925;
spawn_x_jitter = 120;         // variación horizontal
spawn_margin   = 32;

spawn_check_time = 60;
spawn_variance   = 45;        // +/- pasos de variación en el intervalo

max_alive    = 1;             // subilo a 2 o 3 para oleadas
alive_count  = 0;
enemy_alive  = false;         // se mantiene por compatibilidad