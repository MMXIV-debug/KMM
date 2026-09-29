if (room != room_actual)
{
    // Detener música anterior
    if (aud != -1 && audio_is_playing(aud))
    {
        audio_stop_sound(aud);
    }

    room_actual = room;
    aud = -1;

    // Música de cada room
    if (room == RoomIMenu || room == RoomJTutorial)
    {
        aud = audio_play_sound(snd_menu_tutorial, 1000, true);
    }
    else if (room == RoomK)
    {
        aud = audio_play_sound(snd_roomK, 1000, true);
    }
    else if (room == RoomL)
    {
        aud = audio_play_sound(snd_roomL, 1000, true);
    }
    else if (room == RoomS)
    {
        aud = audio_play_sound(snd_roomS, 1000, true);
    }
    else if (room == RoomVEnd)
    {
        aud = audio_play_sound(snd_roomVEnd, 1000, false);
    }
}