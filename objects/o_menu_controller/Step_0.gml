if(keyboard_check_pressed(vk_anykey))
{
    room_goto(RoomJTutorial);
}

if(keyboard_check_pressed(vk_anykey) && room == RoomVEnd)
{
	room_goto(RoomIMenu);
	global.pass += 1;
}