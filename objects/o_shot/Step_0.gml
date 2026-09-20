// Control de direccion

image_angle = direction; // La bala rota apuntando hacia el suelo conforme cae

if (y > room_height || x < 0 || x > room_width) 
{
    instance_destroy();
}
