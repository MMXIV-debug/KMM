song_done = false;

if (room == RoomIMenu)
{
    if (c_any_input_pressed())
    {
        global.total_deaths = 0; // nueva partida: contador en cero
        room_goto(RoomJTutorial);
    }
}
else if (room == RoomVEnd)
{
    // Terminó la canción cuando ya no suena en o_sound
    song_done = instance_exists(o_sound) && o_sound.room_actual == RoomVEnd && !audio_is_playing(o_sound.aud);

    if (song_done && c_any_input_pressed())
    {
        global.pass += 1;
        room_goto(RoomIMenu);
    }
}