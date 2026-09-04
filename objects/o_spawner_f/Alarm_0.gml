/// @description spawn-time
// Lo spawnea en las coordenadas
instance_create_layer(x, y, "Instances", o_enemy_fast);

// Resetea la alarmita indefinidamente
alarm[0] = spawn_time;
