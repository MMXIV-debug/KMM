function c_weapon_spread()
{
    var cantidad = 10;

    // Arco de disparo hacia arriba
    var angulo_inicial = 150;
    var angulo_final = 30;

    for (var i = 0; i < cantidad; i++)
    {
        var angulo = lerp(
            angulo_inicial,
            angulo_final,
            i / (cantidad - 1)
        );

        var bala = instance_create_layer(
            x,
            y - 20,
            "att",
            o_spread_shoot
        );

        bala.direction = angulo;
        bala.speed = 8;

        // Si el sprite apunta hacia arriba
        bala.image_angle = bala.direction - 90;
    }
}