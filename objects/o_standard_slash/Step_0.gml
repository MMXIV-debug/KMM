// Se mantiene pegado adelante del player mientras dura el ataque
if (instance_exists(o_player))
{
    x = o_player.x + (60 * facing);
    y = o_player.y;
}
// Golpea a todos los enemigos que toque, una sola vez cada uno
var found = ds_list_create();
var count = instance_place_list(x, y, o_enemy_body, found, false);

for (var i = 0; i < count; i++)
{
    var enemy = found[| i];
    if (ds_list_find_index(hit_list, enemy) == -1)
    {
        enemy.hp -= dmg;
        ds_list_add(hit_list, enemy);
    }
}

ds_list_destroy(found);