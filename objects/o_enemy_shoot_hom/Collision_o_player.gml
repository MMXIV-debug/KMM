if (room == RoomS && o_player.parry_active)
{
    with (o_player) { c_player_register_parry(); }
    instance_destroy();
    exit;
}

var damage_amount = dmg;

with (o_player)
{
    c_player_take_damage(damage_amount);
}

instance_destroy();