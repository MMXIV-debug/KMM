if (other.weapon == "Homing")
{
    other.pending_weapon = "Homing";
}

other.weapon = "Spread";
other.overdrive_shots_left = 5;

instance_destroy();