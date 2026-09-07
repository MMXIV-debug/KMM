if (!array_contains(other.weapon_slots, "Spin"))
{
    array_push(other.weapon_slots, "Spin");

    other.total_weapons = array_length(other.weapon_slots);

    show_debug_message("¡SPIN DESBLOQUEADO!");
}

instance_destroy();