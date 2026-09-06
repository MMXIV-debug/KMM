if (invuln_timer > 0 && (invuln_timer div 4) % 2 == 0)
{
    gpu_set_blendmode(bm_add);
    draw_self();
    gpu_set_blendmode(bm_normal);
}
else
{
    draw_self();
}