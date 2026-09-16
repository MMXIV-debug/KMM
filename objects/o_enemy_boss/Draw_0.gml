/// @description - HealthBar

draw_self()

if(state = "fight")
{
	draw_set_colour(c_red)
	draw_rectangle(64, 16, 64 + (hp * 1080 / hpMax), 24, false);
}