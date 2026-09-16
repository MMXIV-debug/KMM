if (!instance_exists(o_player)) { instance_destroy(); exit; }

// anclado al player: esto es lo que mantiene el feel cuerpo a cuerpo
x = o_player.x + start_offset * facing_dir;
y = o_player.y;

if (state == "extend")
{
    length += extend_speed;
    if (length >= max_range) { length = max_range; state = "retract"; }
}
else
{
    length -= retract_speed;
    if (length <= 0) { instance_destroy(); exit; }
}

var tip_x = x + length * facing_dir;
var tip_y = y;

// Daño a todo lo que toque la linea, una sola vez por enemigo
var found = ds_list_create();
var count = collision_line_list(x, y, tip_x, tip_y, o_enemy_body, false, true, found, false);

for (var i = 0; i < count; i++)
{
    var e = found[| i];
    if (ds_list_find_index(hit_list, e) == -1)
    {
        e.hp -= dmg;
        ds_list_add(hit_list, e);

        var dirp = point_direction(e.x, e.y, x, y);
        e.x += lengthdir_x(knockback, dirp);
        e.y += lengthdir_y(knockback, dirp);
    }
}
ds_list_destroy(found);

