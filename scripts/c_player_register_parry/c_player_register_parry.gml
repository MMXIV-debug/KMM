function c_player_register_parry()
{
    parry_charge = min(parry_charge + parry_charge_per_hit, parry_charge_max);
    if (parry_charge >= parry_charge_max) charged_shot_ready = true;

    invuln_timer = max(invuln_timer, 10); // chispa de i-frames extra al conectar el parry
}