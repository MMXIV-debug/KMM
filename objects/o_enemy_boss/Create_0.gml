// Stats ---------------------------

hpMax = 250;
hp = hpMax;

dmg =20000000000000000000000000000000000000000000000;

vSpeed = 1.5; //Velocidad a la que va a la derecha
hSpeed = 4; //Velocidad que va hacia arriba y abajo

image_xscale = 3;
image_yscale = 3;

canShoot = 1;
reloadSpeed = 75;  //Equivale a 1.25 * room_speed

target_x = room_width - 600; //Lugar final antes del cambio

ShootDir = 0 // o_player.direction;

weaponType = ["standard", "beam", "multi", "homing"]
weapon = "standard"
state = "enter";
Timer = 5;

moveUp = 1;

// Comportamiento ---------------------------