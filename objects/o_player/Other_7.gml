// Animation End: termina la animacion de ataque
if (sprite_index == s_att_sword || sprite_index == s_att_bucket)
{
    is_attacking = false;

    // Si termino la animacion de espada, destruir el hitbox de slash
    if (sprite_index == s_att_sword)
    {
        with (o_standard_slash)
        {
            if (ds_exists(hit_list, ds_type_list)) ds_list_destroy(hit_list);
            instance_destroy();
        }
    }

    // Restaurar sprite normal según la sala actual
    if (room == RoomL)
    {
        sprite_index = s_player_2;
    }
    else if (room == RoomS)
    {
        sprite_index = s_player_3;
    }
    else if (room == RoomK)
    {
        sprite_index = s_player_1;
    }
}
