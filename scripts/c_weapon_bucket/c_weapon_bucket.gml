function c_weapon_bucket(_x, _y, _mirando_derecha)
{
    sprite_index = s_att_bucket;
    image_index = 0;
    image_speed = 1;
    is_attacking = true;

    var _cantidad_balas = 10;
    var _apertura = 35;
    var _velocidad_bala = 12;

    // cuánto se eleva el disparo (grados hacia arriba). Subilo/bajalo a gusto.
    var _elevacion = 18;

    // chequeo correcto de hacia dónde mira (facing llega como 1 o -1)
    var _direccion_base = (_mirando_derecha > 0) ? (0 + _elevacion) : (180 - _elevacion);

    var _angulo_inicio = _direccion_base - (_apertura / 2);
    var _separacion = _apertura / (_cantidad_balas - 1);

    // Escala segun la carga del parry
    var _charge_ratio = parry_charge / parry_charge_max;
    var _size_scale = 1 + _charge_ratio * 1.5;
    var _dmg_base   = 10;
    var _dmg_final  = _dmg_base * (1 + _charge_ratio);

    for (var i = 0; i < _cantidad_balas; i++) {
        var _angulo_actual = _angulo_inicio + (i * _separacion);
        var _bala = instance_create_layer(_x, _y, "Instances", o_shot);

        with (_bala) {
            direction = _angulo_actual;
            speed = _velocidad_bala;
            direction += random_range(-2, 2);
            speed += random_range(-1, 1);

            dmg = _dmg_final;
            image_xscale = _size_scale;
            image_yscale = _size_scale;
        }
    }

    parry_charge = 0;
    charged_shot_ready = false;
}