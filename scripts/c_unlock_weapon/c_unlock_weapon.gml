function c_unlock_weapon(_name)
{
    if (!instance_exists(o_player)) return;

    for (var i = 0; i < array_length(o_player.weapon_slots); i++)
    {
        if (o_player.weapon_slots[i] == _name) return; // ya lo tiene
    }

    array_push(o_player.weapon_slots, _name);
    o_player.total_weapons = array_length(o_player.weapon_slots);
    show_debug_message("Arma desbloqueada: " + _name);
}