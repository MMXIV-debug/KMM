function c_weapon_bucket(_x, _y, _mirando_derecha)
{
    // Configuración del disparo
    var _cantidad_balas = 10;
    var _apertura = 35;           
    var _velocidad_bala = 12;
    
    var _direccion_base = _mirando_derecha ? 0 : 270;
    
    var _angulo_inicio = _direccion_base - (_apertura / 2);
    var _separacion = _apertura / (_cantidad_balas - 1);
    
    // Bucle para crear y conectar
    for (var i = 0; i < _cantidad_balas; i++) {
        var _angulo_actual = _angulo_inicio + (i * _separacion);
        
        var _bala = instance_create_layer(_x, _y, "Instances", o_shot);
        
        with (_bala) {
            direction = _angulo_actual;
            speed = _velocidad_bala;
            
            direction += random_range(-2, 2);
            speed += random_range(-1, 1);
        }
    }
}
