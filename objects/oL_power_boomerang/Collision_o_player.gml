if (!array_contains(other.weapon_slots, "Boomerang"))
{
    array_push(other.weapon_slots, "Boomerang");

    other.total_weapons = array_length(other.weapon_slots);

    show_debug_message("¡BOOMERANG DESBLOQUEADO!");
}

instance_destroy();