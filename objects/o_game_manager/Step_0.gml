// Contar el tiempo y spawnear el boss al minuto
if ((room == RoomK || room == RoomL || room == RoomS) && !boss_spawned)
{
    game_timer++;
	
	if (instance_exists(o_player) && o_player.deaths > last_deaths)
	{
	    boss_time += death_penalty * (o_player.deaths - last_deaths);
	    last_deaths = o_player.deaths;
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
        if (room == RoomK && instance_exists(o_player))
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