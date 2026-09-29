// 1. Mueve el objeto
y += vSpeed; 

// 2. Compara con el número exacto 540
if (y >= 540) {
    y = 540;
    vSpeed = 0; 
}

show_debug_message("Posicion Y actual: " + string(y) + " | Velocidad: " + string(vSpeed));