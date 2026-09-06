function c_weapon_spread(argument0)
{
    var cantidad = 10;
    var angulo_inicial = -60;
    var angulo_final = 60;

    var bullet_obj = o_spread_shot;
    switch(argument0)
    {
        case 2: bullet_obj = o_spread_shot_2; break;
        case 3: bullet_obj = o_spread_shot_3; break;
    }

    for (var i = 0; i < cantidad; i++)
    {
        var angulo = lerp(angulo_inicial, angulo_final, i / (cantidad - 1));
        var bala = instance_create_layer(x+30, y, "att", bullet_obj);
        bala.direction = angulo;
        bala.speed = 8;
    }
}