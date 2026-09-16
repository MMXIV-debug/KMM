//Stats
//Atributos
hp = 20;
move_speed = 5;
dmg = 10;

//Extras
gpu_set_texfilter(false);


// Efecto de movimiento 
//Posición inicial
x_inicio = x;
y_inicio = y;

// Fuerza del viento
amplitud = 15;

// Velocidad
velocidad = 0.05;

// Tiempo
tiempo = 0;

// Ángulo máximo de movimiento
angulo_max = 15;

// Extras
var paths = [path_pow_1, path_pow_2];
var chosen_path = paths[irandom(array_length(paths) - 1)];

path_start(chosen_path, move_speed, path_action_stop, false);