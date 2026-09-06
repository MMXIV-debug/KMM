/// @description avisar al manager que ya puede spawnear otro y agregar al contador
if (variable_instance_exists(id, "spawner_id") && instance_exists(spawner_id))
{
    spawner_id.enemy_alive = false;
}
global.kills_since_last_portal++;