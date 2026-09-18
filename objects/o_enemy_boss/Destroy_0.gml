// Detener todos los spawners de enemigos
with (o_enemy_manager)
{
    instance_destroy();
}

if (room == RoomK)
{
    // Spawnear portal permanente hacia RoomL
    var port = instance_create_layer(x, y, "Instances", o_portal);
	port.target_room = RoomL;
    port.alarm[0] = -1; // Sin límite de tiempo: no desaparece
}
else if (room == RoomL)
{
	var port = instance_create_layer(x, y, "Instances", o_portal);
	port.target_room = RoomS;
	port.alarm[0] = -1;
}

else
{
    // Para otras salas (RoomT), enviar al jugador al final
    if (instance_exists(o_player))
    {
        o_player.alarm[11] = 4 * room_speed;
    }
}