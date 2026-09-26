hp  = 40;
dmg = 20;
speed_line = 6;
dmg_cooldown = 0;

var _types = ["horizontal", "vertical", "diagonal"];
var _type = _types[irandom(array_length(_types) - 1)];
var _margin = 60;

switch (_type)
{
    case "horizontal":
        if (irandom(1) == 0)
        {
            x = -_margin; y = irandom_range(_margin, room_height - _margin);
            direction = 0;
        }
        else
        {
            x = room_width + _margin; y = irandom_range(_margin, room_height - _margin);
            direction = 180;
        }
    break;

    case "vertical":
        if (irandom(1) == 0)
        {
            x = irandom_range(_margin, room_width - _margin); y = -_margin;
            direction = 270;
        }
        else
        {
            x = irandom_range(_margin, room_width - _margin); y = room_height + _margin;
            direction = 90;
        }
    break;

    case "diagonal":
        switch (irandom(3))
        {
            case 0: x = -_margin;             y = -_margin;              direction = 45;  break;
            case 1: x = room_width + _margin; y = -_margin;              direction = 135; break;
            case 2: x = room_width + _margin; y = room_height + _margin; direction = 225; break;
            case 3: x = -_margin;             y = room_height + _margin; direction = 315; break;
        }
    break;
}

speed = speed_line;
image_angle = direction;
spawner_id = noone;

// Guardamos el punto de partida para dibujar/chequear el rastro
origin_x = x;
origin_y = y;

// Rastro peligroso que deja detrás
trail_tick_interval = 15;   // chequea daño cada 0.25s
trail_tick_timer    = 0;
trail_dmg           = 8;

// Disparo teledirigido mientras se mueve
canShoot    = true;
reloadSpeed = 70;