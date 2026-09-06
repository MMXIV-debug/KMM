if (other.weapon == "Spread")
{
    // Overdrive activo: el Homing queda en cola, no lo reemplaza
    other.pending_weapon = "Homing";
}
else
{
    other.weapon = "Homing";
}
instance_destroy();