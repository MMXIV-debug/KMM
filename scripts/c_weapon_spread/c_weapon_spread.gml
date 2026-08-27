function c_weapon_spread()
{
    var cantidad = 10;

    // Arco apuntando hacia la derecha
    var angulo_inicial = -60;
    var angulo_final = 60;

    for (var i = 0; i < cantidad; i++)
    {
        var angulo = lerp(
            angulo_inicial,
            angulo_final,
            i / (cantidad - 1)
        );

        var bala = instance_create_layer(
            x,
            y,
            "att",
            o_spread_shoot
        );

        bala.direction = angulo;
        bala.speed = 8;
    }
}