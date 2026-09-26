if (state == "flying")
{
    dist_traveled += speed;
    if (dist_traveled >= travel_dist)
    {
        speed = 0;
        state = "armed";
        alarm[0] = explode_delay;
    }
}

if (x < -50 || x > room_width + 50 || y < -50 || y > room_height + 50)
{
    instance_destroy();
}