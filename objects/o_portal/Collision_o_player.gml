/// @description ir a la room configurada por quien creó el portal

if (target_room == RoomL)
{
    global.weapon_override = "Slash";
}

if (target_room == RoomS)
{
	global.weapon_override = "bucket";
}
show_debug_message("Room elegida: " + room_get_name(target_room));

room_goto(target_room);