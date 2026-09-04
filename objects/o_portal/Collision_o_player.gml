/// @description ir a una room al azar

var rooms = [RoomL, RoomS];
//var chosen_room = rooms[irandom(1)];
var chosen_room = RoomL; // 🔧 TEMPORAL para testear

if (chosen_room == RoomL)
{
    global.weapon_override = "Slash";
}

show_debug_message("Room elegida: " + room_get_name(chosen_room) + " | override: " + (variable_global_exists("weapon_override") ? global.weapon_override : "NO EXISTE"));

room_goto(chosen_room);