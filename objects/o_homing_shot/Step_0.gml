var target = instance_nearest(x, y, o_enemy_body);

if (target != noone)
{
    var target_dir = point_direction(x, y, target.x, target.y);
    var diff = angle_difference(target_dir, direction);
    direction += clamp(diff, -turn_rate, turn_rate);
}

speed = move_speed;
image_angle = direction - 90;

if (x < -50 || x > room_width + 50 || y < -50 || y > room_height + 50)
{
    instance_destroy();
}