// Solo activo en RoomK: contar el tiempo y spawnear el boss al minuto
if (room == RoomK && !boss_spawned)
{
    game_timer++;
	if (o_player.is_dead)
	{
		boss_time += 30;
	}
    if (game_timer >= boss_time)
    {
        boss_spawned = true;
        // Desactivar todos los spawners de enemigos comunes
        with (o_enemy_manager)
        {
            instance_destroy();
        }
        
        // Si el jugador tiene Homing, se lo quitamos y volvemos a Standard
        if (instance_exists(o_player))
        {
            if (o_player.weapon == "Homing")
            {
                o_player.weapon = "Standard";
                o_player.powlvl = 1;
            }
            if (o_player.pending_weapon == "Homing")
            {
                o_player.pending_weapon = "";
            }
        }

        // Boss entra desde la derecha hacia la mitad de pantalla
        instance_create_layer(room_width + 100, room_height / 2, "Instances", o_enemy_boss);
    }
}