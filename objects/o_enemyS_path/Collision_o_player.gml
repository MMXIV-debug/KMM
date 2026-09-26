if (dmg_cooldown <= 0)
{
    with (o_player) 
	{ 
		c_player_take_damage(other.dmg); 
	}
    dmg_cooldown = 30; // medio segundo de invulnerabilidad ante este enemigo
}