function c_player_take_damage(amount)
{
    if (invuln_timer > 0)
    {
        exit; // ignorar el golpe, todavía invulnerable
    }

    hp -= amount;
    invuln_timer = invuln_duration;

    if (weapon == "Homing")
    {
        weapon = "Standard";
    }
	powlvl = max(powlvl - 1, 1);
}