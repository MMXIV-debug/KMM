# 🎮 Soporte de Gamepad Xbox One — KMM

**Fecha:** 2026-09-16  
**Archivos modificados:** `o_player/Create_0.gml`, `o_player/Step_0.gml`

---

## Descripción

Se implementó soporte para control con **joystick Xbox One** manteniendo compatibilidad total con el teclado existente. El juego ahora acepta **input dual simultáneo**: si hay un gamepad conectado, sus botones y ejes funcionan en paralelo con el teclado. El jugador puede usar cualquiera de los dos en cualquier momento.

---

## Mapeo de controles

| # | Acción | Teclado | Xbox One |
|---|---|---|---|
| 1 | Movimiento | `W A S D` | **Left Stick** (analógico) |
| 2 | Ataque | `J` | **B** |
| 3 | Dash | `I` | **RB** (bumper derecho) |
| 4 | Cambio de arma (RoomK / RoomL) | `K` | **D-Pad →** (derecha) |
| 5 | Poder Final | — | **LT** (trigger izquierdo) |
| 6 | Absorber / Parry | — | **RT** (trigger derecho) |
| 7 | Mecánica extra | — | **D-Pad ↓** (abajo) |

---

## Cambios por archivo

### `objects/o_player/Create_0.gml`

- Se inicializa `pad_num = -1` y se busca automáticamente el **primer gamepad conectado** en los slots 0–3.
- Se configura `gamepad_set_axis_deadzone(pad_num, 0.25)` para evitar drift del stick.
- Se agregaron comentarios de referencia con las constantes de botones de GameMaker (`gp_face1`, `gp_face2`, `gp_shoulderr`, etc.).
- Se inicializan `lt_prev` y `rt_prev` para la detección de "pressed" en los triggers.

```gml
// Buscar el primer gamepad conectado
for (var _i = 0; _i < 4; _i++)
{
    if (gamepad_is_connected(_i))
    {
        pad_num = _i;
        gamepad_set_axis_deadzone(pad_num, pad_dead_zone);
        break;
    }
}
```

### `objects/o_player/Step_0.gml`

- Se lee el **Left Stick** con `gamepad_axis_value(pad, gp_axislh/gp_axislv)`. El stick tiene **prioridad sobre WASD** cuando hay input analógico activo.
- Se combinan inputs con OR lógico en cada acción: `_do_attack = keyboard_check_pressed(ord("J")) || _btn_attack_pad`.
- **LT y RT son ejes continuos** (rango 0..1), no botones. Se implementó detección de "pressed" usando variables `lt_prev` / `rt_prev` para que solo disparen en el primer frame, igual que un botón digital.
- Se agregaron bloques con `// TODO` para **Poder Final** (LT), **Parry** (RT) y **Mecánica extra** (D-Pad ↓), listos para conectar con su lógica cuando esté implementada.

---

## Detalles técnicos

### Dead Zone
El stick analógico tiene una dead zone de `0.25` (25% del recorrido total). Esto evita que el personaje se mueva solo por drift o imprecisión del hardware.

### Detección de triggers (LT / RT)
Los triggers del Xbox One son **ejes analógicos** en GameMaker, no botones. Para simular el comportamiento de "presionado una vez":

```gml
var _lt_held = gamepad_axis_value(_pad, gp_shoulderlb) > 0.15;
var _btn_final_pressed = _lt_held && !lt_prev;  // solo true en el primer frame
lt_prev = _lt_held;
```

### Compatibilidad de teclado
Todos los controles de teclado originales siguen funcionando sin cambios:

| Acción | Tecla original |
|---|---|
| Movimiento | `WASD` |
| Ataque | `J` |
| Dash | `I` |
| Cambio arma | `K` |

---

## TODOs pendientes

Los siguientes inputs están **detectados y con log de debug**, pero esperan su implementación de lógica de juego:

- [ ] **LT → Poder Final**: conectar con el sistema de poder especial del jugador.
- [ ] **RT → Absorber/Parry**: conectar con la mecánica de parry/absorción.
- [ ] **D-Pad ↓ → Mecánica extra**: conectar con la mecánica extra correspondiente.

Buscar los comentarios `// TODO` en `Step_0.gml` para localizar exactamente dónde insertar la lógica.

---

## Constantes de botones Xbox One en GameMaker

| Constante GML | Botón físico |
|---|---|
| `gp_face1` | A |
| `gp_face2` | **B** |
| `gp_face3` | X |
| `gp_face4` | Y |
| `gp_shoulderl` | LB |
| `gp_shoulderr` | **RB** |
| `gp_shoulderlb` | **LT** (eje) |
| `gp_shoulderrb` | **RT** (eje) |
| `gp_padr` | **D-Pad →** |
| `gp_padl` | D-Pad ← |
| `gp_padu` | D-Pad ↑ |
| `gp_padd` | **D-Pad ↓** |
| `gp_axislh` | Left Stick horizontal |
| `gp_axislv` | Left Stick vertical |
| `gp_axisrh` | Right Stick horizontal |
| `gp_axisrv` | Right Stick vertical |
