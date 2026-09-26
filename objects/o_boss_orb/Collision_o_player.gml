if (room == RoomS && o_player.parry_active)
{
    with (o_player) { c_player_register_parry(); }
    instance_destroy();
}