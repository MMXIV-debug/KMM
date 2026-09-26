// Inherit the parent event
event_inherited();

// Variante "estrella"
shots_fired  = 0;
max_shots    = 3;     // se retira después de 3 ráfagas
bullet_count = 10;    // cantidad de proyectiles por ráfaga (ajustá a gusto)
bullet_speed = 6;

drop_chance = 0;      // nunca suelta power-up
alarm[1] = -1;        // no usamos el timer de huida del padre, huimos por conteo de disparos