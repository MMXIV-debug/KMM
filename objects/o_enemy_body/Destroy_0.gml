/// @description avisar al manager que ya puede spawnear otro y agregar al contador
if (variable_instance_exists(id, "spawner_id") && instance_exists(spawner_id))
{
    spawner_id.alive_count = max(0, spawner_id.alive_count - 1);
    spawner_id.enemy_alive = false;
}

global.kills_since_last_portal++;

if (object_index == o_enemy_laser)
{
    c_unlock_weapon("Bomb");
}

if (room == RoomL)
{
    global.roomL_kills++;

    if (global.roomL_kills >= 5)
    {
        var ya_desbloqueado = false;
        for (var i = 0; i < array_length(o_player.weapon_slots); i++)
        {
            if (o_player.weapon_slots[i] == "Hook") ya_desbloqueado = true;
        }

        if (!ya_desbloqueado)
        {
            array_push(o_player.weapon_slots, "Hook");
            show_debug_message("¡Gancho desbloqueado!");
        }
    }
}