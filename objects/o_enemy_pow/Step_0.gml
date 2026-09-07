// Inherit the parent event
event_inherited();

// Avanza el tiempo
tiempo += velocidad;

// Movimiento de balanceo
image_angle = sin(tiempo) * angulo_max;

