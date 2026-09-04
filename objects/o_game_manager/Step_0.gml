// Chequeo del tiempo (una sola vez)
if (!thirty_seconds_reached)
{
    game_timer++;
    if (game_timer >= 30 * room_speed)
    {
        thirty_seconds_reached = true;
    }
}

// Chequeo repetido: cada 20 kills, una vez pasado el tiempo mínimo
if (thirty_seconds_reached && global.kills_since_last_portal >= 20)
{
    var px = irandom_range(spawn_margin, room_width - spawn_margin);
    var py = irandom_range(spawn_margin, room_height - spawn_margin);

    instance_create_layer(px, py, "Instances", o_portal);

    global.kills_since_last_portal = 0; // se reinicia para el próximo ciclo de 20
}