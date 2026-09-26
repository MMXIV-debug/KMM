# KMM — Top Down Shooter

Proyecto de videojuego de acción desarrollado en **GameMaker** (lenguaje GML). Propone un modo de juego tipo shooter de desplazamiento horizontal con vista superior, organizado en múltiples niveles de dificultad creciente. El jugador enfrenta oleadas de enemigos con comportamientos diferenciados, acumula armas y potenciadores, y progresa a través de salas hasta llegar a una pantalla de fin de partida.

---

## Tabla de contenidos

1. [Descripción general](#1-descripción-general)
2. [Objetivo del proyecto](#2-objetivo-del-proyecto)
3. [Tecnologías y herramientas](#3-tecnologías-y-herramientas)
4. [Estructura del proyecto](#4-estructura-del-proyecto)
5. [Flujo de juego y salas](#5-flujo-de-juego-y-salas)
6. [Controles](#6-controles)
7. [Entidad del jugador](#7-entidad-del-jugador)
8. [Sistema de armas](#8-sistema-de-armas)
9. [Potenciadores (Power-Ups)](#9-potenciadores-power-ups)
10. [Enemigos](#10-enemigos)
11. [El jefe final (`o_enemy_boss`)](#11-el-jefe-final-o_enemy_boss)
12. [Sistemas gestores](#12-sistemas-gestores)
13. [Interfaz de usuario (HUD)](#13-interfaz-de-usuario-hud)
14. [Scripts globales](#14-scripts-globales)
15. [Interacciones entre sistemas](#15-interacciones-entre-sistemas)
16. [Estado actual del proyecto](#16-estado-actual-del-proyecto)
17. [Funcionalidades pendientes](#17-funcionalidades-pendientes)

---

## 1. Descripción general

El juego es un shooter de desplazamiento horizontal con vista superior. El jugador controla a un personaje que se mueve libremente dentro del área de la sala y debe eliminar oleadas de enemigos que avanzan desde el lado derecho u otras direcciones según el nivel. A medida que progresa, el jugador desbloquea nuevas armas, recoge potenciadores y enfrenta jefes con patrones de ataque específicos para cada sala.

El proyecto está organizado en **tres salas de combate principales**, cada una con su propio conjunto de enemigos, mecánicas de armas disponibles y comportamiento del jefe:

| Sala | Tipo de jugabilidad | Armas disponibles |
|---|---|---|
| `RoomK` | Shooter a distancia | Standard, Spread (Overdrive), Homing |
| `RoomL` | Combate cuerpo a cuerpo / táctico | Slash, Hook, Bomb |
| `RoomS` | Shooter mixto con jefe de tres fases | Sistema en desarrollo |

---

## 2. Objetivo del proyecto

- Explorar y desarrollar mecánicas de juego propias inspiradas en géneros de acción tipo shooter.
- Implementar un sistema de armas modular intercambiable por sala.
- Diseñar enemigos con comportamientos variados y escalables en dificultad.
- Construir un jefe final adaptable con patrones de ataque distintos según el escenario.
- Integrar soporte completo para teclado y gamepad (Xbox One) de manera simultánea.

---

## 3. Tecnologías y herramientas

| Elemento | Detalle |
|---|---|
| **Motor de juego** | GameMaker (versión compatible con GML moderno) |
| **Lenguaje** | GML (GameMaker Language) |
| **Control** | Teclado (WASD + teclas de acción) y Gamepad Xbox One (soporte dual) |
| **Sistema de rutas** | Rutas de GameMaker (`path_start`) para movimiento de enemigos kamikaze y potenciadores |
| **Gestión de estado** | Máquinas de estado finitas implementadas con `switch` / variables de estado por objeto |
| **Control de versiones** | Git (`.gitattributes` y `.gitignore` incluidos) |

---

## 4. Estructura del proyecto

```
Top Down Shooter/
├── objects/          # Todos los objetos del juego (jugador, enemigos, proyectiles, managers)
├── scripts/          # Scripts reutilizables (armas, daño, desbloqueos)
├── rooms/            # Salas del juego (menú, tutorial, niveles, fin)
├── sprites/          # Gráficos del jugador, enemigos, fondos, UI
├── sounds/           # Recursos de audio
├── paths/            # Rutas predefinidas para movimiento de enemigos y power-ups
├── animcurves/       # Curvas de animación
├── datafiles/        # Archivos de datos adicionales
├── options/          # Configuración del proyecto GameMaker
└── Top Down Shooter.yyp  # Archivo principal del proyecto
```

### Objetos principales

| Categoría | Objetos |
|---|---|
| **Jugador** | `o_player` |
| **Jefe** | `o_enemy_boss` |
| **Enemigos (RoomK)** | `o_enemy_fast`, `o_enemy_slow`, `o_enemy_laser`, `o_enemy_pow` |
| **Enemigos (RoomL)** | `o_enemyL_fast`, `o_enemyL_slow` |
| **Enemigos (RoomS)** | `o_enemyS_slow`, `o_enemyS_spread`, `o_enemyS_path`, `o_enemyS_orb` |
| **Proyectiles enemigos** | `o_enemy_shoot_hom`, `o_boss_orb` |
| **Armas del jugador** | `o_standard_slash`, `o_hook_shot`, `o_bomb`, `o_homing_shot`, `o_standard_shot`, `o_spread_shot` (y variantes nivel 2/3) |
| **Power-Ups** | `o_power_plus`, `o_power_homing`, `o_power_overdrive`, `oL_power_boomerang`, `oL_power_spin` |
| **Gestores** | `o_game_manager`, `o_enemy_manager` |
| **Navegación** | `o_portal`, `o_menu_controller`, `o_tutorial_controller` |

### Scripts

| Script | Función |
|---|---|
| `c_weapon_standard` | Disparo estándar frontal (3 niveles de daño) |
| `c_weapon_spread` | Disparo en cono de 120° (10 proyectiles, 3 niveles) |
| `c_weapon_homing` | Misil teledirigido (3 niveles de daño) |
| `c_weapon_slash` | Golpe cuerpo a cuerpo frontal |
| `c_weapon_hook` | Látigo energético con knockback |
| `c_weapon_bomb` | Bomba adherente de dos pulsaciones |
| `c_weapon_bucket` | Disparo en abanico escalado por carga de parry |
| `c_player_take_damage` | Aplicar daño al jugador con invulnerabilidad |
| `c_player_register_parry` | Registrar impacto de parry y cargar el medidor |
| `c_bomb_explode` | Explosión radial con daño a enemigos y al jugador |
| `c_unlock_weapon` | Agregar un arma al inventario del jugador (sin duplicados) |

---

## 5. Flujo de juego y salas

El juego sigue una secuencia lineal de salas:

```
RoomIMenu → RoomJTutorial → RoomK → RoomL → RoomS → RoomVEnd
```

### `RoomIMenu` — Menú principal
Pantalla de inicio con dos botones: **JUGAR** y **SALIR**. Al pulsar JUGAR por primera vez, navega a `RoomJTutorial`. El fondo usa el sprite `s_fondo_menu` y el título `s_titulo`.

### `RoomJTutorial` — Tutorial
Sala de introducción controlada por `o_tutorial_controller`. Al presionar cualquier tecla (y no estar en `RoomT`), avanza automáticamente a `RoomK`.

### `RoomK` — Primera sala de combate
- **Mecánica de armas:** shooter a distancia con armas Standard, Homing y Spread (Overdrive temporal).
- **Temporizador de jefe:** el jefe aparece exactamente al minuto de juego (`boss_time = 60 * room_speed`). Cada muerte del jugador añade 15 segundos adicionales de espera.
- **Antes del jefe:** el `o_game_manager` elimina todos los spawners de enemigos comunes cuando llega el momento.
- **Restricción especial:** si el jugador porta el arma Homing en el momento en que aparece el jefe, esta se reemplaza automáticamente por Standard (nivel 1).
- **Al vencer al jefe:** aparece un portal permanente hacia `RoomL`.

### `RoomL` — Segunda sala de combate
- **Mecánica de armas:** combate físico y táctico (Slash, Hook, Bomb). El jugador siempre empieza con Slash al ingresar.
- **Desbloqueo de Gancho:** al acumular 5 kills en esta sala, se desbloquea automáticamente el arma Hook.
- **Desbloqueo de Bomba:** al eliminar al enemigo `o_enemy_laser`, se desbloquea el arma Bomb.
- **Temporizador de jefe:** igual que en RoomK (1 minuto + penalización por muertes).
- **Al vencer al jefe:** aparece un portal permanente hacia `RoomS`.

### `RoomS` — Tercera sala de combate (en desarrollo)
- Enemigos exclusivos: `o_enemyS_slow` (tirador en estrella), `o_enemyS_spread` (lanzador de orbes), `o_enemyS_path` (línea de daño en trayectoria cruzada).
- El jefe aquí rota tres fases de ataque: homing → láser → orbe explosivo.
- La sala cuenta con spawners independientes para cada tipo de enemigo.

### `RoomVEnd` — Pantalla de fin
El jugador llega aquí una vez derrotado el jefe en la sala final (`RoomS` o según progresión). La transición se activa mediante `o_player.alarm[11]`.

---

## 6. Controles

El juego soporta **teclado y gamepad Xbox One de forma simultánea**. Si hay un gamepad conectado en los slots 0–3, se detecta automáticamente y se configura con una zona muerta del 25% en el stick analógico.

| Acción | Teclado | Xbox One |
|---|---|---|
| Movimiento | `W` `A` `S` `D` | Left Stick (analógico) |
| Ataque / Disparar | `J` | `B` |
| Dash | `I` | `RB` (bumper derecho) |
| Cambiar arma | `K` | `D-Pad →` |
| Poder Final *(pendiente)* | — | `LT` (trigger izquierdo) |
| Absorber / Parry *(pendiente)* | — | `RT` (trigger derecho) |
| Mecánica extra *(pendiente)* | — | `D-Pad ↓` |

**Notas técnicas:**
- El Left Stick tiene **prioridad sobre WASD** cuando produce input analógico activo.
- Los triggers `LT` y `RT` son ejes continuos (rango 0..1). Se detectan como "presionados" cuando superan el umbral del 15%, usando variables `lt_prev` / `rt_prev` para simular comportamiento de botón digital (solo dispara en el primer frame de presión).
- El movimiento produce un vector normalizado para evitar velocidad mayor en diagonales.

---

## 7. Entidad del jugador

### Estadísticas base

| Variable | Valor | Descripción |
|---|---|---|
| `max_hp` | 100 | Puntos de vida máximos |
| `total_hearts` | 6 | Corazones mostrados en el HUD |
| `move_speed` | 9 px/step | Velocidad de movimiento |
| `dash_speed` | 20 px/step | Velocidad durante el dash |
| `dash_duration` | 12 steps | Duración del dash (~0.2 s) |
| `dash_cooldown` | 30 steps | Espera entre dashes (~0.5 s) |
| `attack_cooldown` | 20 steps | Cadencia de ataque base |
| `invuln_duration` | 60 steps | Invulnerabilidad post-impacto (1 s) |
| `respawnTime` | 1 * room_speed | Tiempo de reaparición tras morir |
| `powlvl` | 1 (máx. 3) | Nivel de poder del arma |

### Ciclo de vida y respawn

Cuando el jugador recibe daño suficiente para llegar a 0 HP:
1. Se activa la bandera `is_dead = true` y se incrementa el contador `deaths`.
2. La entidad se desplaza fuera de la cámara (`y -= 2000`) para desaparecer visualmente.
3. Se activa `alarm[1]` con el tiempo de reaparición.
4. Al activarse la alarma, el jugador regresa a la posición de inicio `(64, 576)`, recupera todo el HP y vuelve al nivel de poder 1.

### Invulnerabilidad

Cada vez que el jugador recibe daño, se activa un período de invulnerabilidad de 60 steps durante el cual ningún impacto posterior tiene efecto. Durante este tiempo el sprite parpadea utilizando blending aditivo (`bm_add`), produciendo un efecto de destello visual.

### Facing (orientación del sprite)

El jugador tiene una variable `facing` (1 = derecha, −1 = izquierda) que voltea el sprite horizontalmente (`image_xscale = facing`). En `RoomK`, `RoomS` y `RoomT`, el facing no se actualiza con el movimiento (queda fijo), mientras que en `RoomL` y el tutorial sí se actualiza con la dirección horizontal del jugador.

### Sprites por sala

| Sala | Sprite en reposo | Sprite de ataque (espada) | Sprite de ataque (balde) |
|---|---|---|---|
| `RoomK` | `s_player_1` | `s_att_sword` | — |
| `RoomL` | `s_player_2` | `s_att_sword` | `s_att_bucket` |
| `RoomS` | `s_player_3` | — | — |

### Límites de sala

El jugador no puede salir de los límites de la sala. Cada step se verifican los cuatro bordes del bounding box y la posición se corrige para mantenerlo dentro del área de juego.

---

## 8. Sistema de armas

### Armas en `RoomK` y `RoomT`

En estas salas el jugador usa el sistema de arma activa (`weapon`), que puede ser:

#### Standard
Dispara un proyectil recto hacia la derecha. El tipo de proyectil varía según `powlvl`:
- Nivel 1: `o_standard_shot` — 10 de daño, velocidad 15 px/step
- Nivel 2: `o_standard_shot_2` — 20 de daño
- Nivel 3: `o_standard_shot_3` — 30 de daño

#### Homing (misil teledirigido)
Dispara un proyectil que persigue al enemigo más cercano. Cada step calcula la dirección al objetivo con `instance_nearest` y ajusta gradualmente la trayectoria con `turn_rate = 6` grados por step, produciendo un giro suave. El daño varía por nivel de poder: 10 / 20 / 30.

Si el jugador recibe daño mientras tiene Homing equipada, el arma se degrada automáticamente a Standard.

#### Spread — Overdrive temporal
Se activa al recoger el power-up `o_power_overdrive`. Dispara 10 proyectiles en un cono de 120° (de −60° a +60°). Solo están disponibles **5 disparos** (`overdrive_shots_left = 5`). Al agotarse regresa automáticamente al arma anterior (ya sea Standard o Homing, según lo que estuviera en `pending_weapon`).

El daño varía por nivel: 10 / 20 / 30 por proyectil.

### Armas en `RoomL`

En esta sala el jugador gestiona un **inventario de armas** almacenado en el array `weapon_slots`. Empieza únicamente con `["Slash"]` y desbloquea más durante la partida. El cambio de arma es cíclico (tecla `K` o D-Pad →) y la variable `weapon_RoomL` indica el arma activa.

#### Slash
Genera una instancia de `o_standard_slash` a 80 píxeles por delante del jugador (ajustado por `facing`). El hitbox dura 15 steps y aplica 15 de daño. Utiliza una `ds_list` interna para garantizar que cada enemigo solo reciba el daño una vez por activación, incluso si permanece en contacto durante varios frames.

#### Hook (Gancho)
Genera `o_hook_shot`, un látigo de energía que:
1. Se extiende 340 px a `extend_speed = 25` px/step desde la posición del jugador.
2. Al alcanzar el máximo, se retrae a `retract_speed = 30` px/step.
3. Detecta colisiones con `collision_line_list` a lo largo de toda su línea.
4. Aplica 12 de daño por enemigo tocado y los empuja hacia el jugador con un knockback de 24 px.
5. Cada enemigo solo es golpeado una vez por disparo (lista `hit_list`).

**Desbloqueo:** al acumular 5 kills en `RoomL`.

#### Bomb (Bomba adherente)
Funciona con dos pulsaciones del botón de ataque:
1. **Primera pulsación:** lanza `o_bomb` horizontalmente a velocidad 20 px/step. Si toca a un enemigo antes de recorrer 420 px, se adhiere a él (estado `"stuck"`) siguiendo sus coordenadas mediante un offset relativo (`off_x`, `off_y`). Si no impacta, queda flotando en estado `"idle"`.
2. **Segunda pulsación:** detona la bomba. Llama a `c_bomb_explode()` con un radio de 160 px y 60 de daño. La explosión afecta a todos los enemigos en el radio, incluyendo al jefe. **La explosión también puede dañar al jugador** si está dentro del radio (15 de daño fijo).

**Advertencia:** si el objetivo al que está adherida la bomba muere antes de la detonación, la bomba se destruye automáticamente.

**Desbloqueo:** al eliminar al enemigo `o_enemy_laser` en RoomL.

#### Bucket (Balde cargado por Parry) — *en desarrollo parcial*
Script `c_weapon_bucket` implementado. Dispara 10 proyectiles en un abanico de 35° con elevación configurable. El daño base es 1000, escalado según la carga del medidor de parry (`parry_charge`). El tamaño de los proyectiles también escala con la carga. Al disparar, el medidor de parry se reinicia a 0. Este sistema depende de variables de parry (`parry_charge`, `parry_charge_max`, `charged_shot_ready`) que no están inicializadas en el `Create` actual del jugador.

---

## 9. Potenciadores (Power-Ups)

Los power-ups se mueven horizontalmente usando el objeto padre `o_pwr` (velocidad `x -= vSpeed = 5`). Al colisionar con el jugador, ejecutan su efecto y se destruyen.

### `o_power_plus` — Subida de nivel
Incrementa `powlvl` en 1, hasta el máximo de 3. Mejora el daño de Standard, Homing y Spread.

### `o_power_homing` — Arma Homing
Cambia el arma activa del jugador a `"Homing"`. Si el jugador está en modo Overdrive (Spread), el arma Homing queda en cola (`pending_weapon = "Homing"`) y se aplica al terminar los disparos de Overdrive.

### `o_power_overdrive` — Modo Overdrive (Spread)
Activa el arma Spread temporalmente con 5 cargas. Si el jugador tenía Homing, la guarda en `pending_weapon`. El arma regresa a la anterior al agotar las cargas.

### `oL_power_boomerang` — Desbloqueo Boomerang *(RoomL)*
Al colisionar con el jugador, agrega `"Boomerang"` al array `weapon_slots` si no lo tiene ya. Uso de `array_push` y `array_contains` para evitar duplicados.

> **Nota:** el arma Boomerang aparece en el sistema de desbloqueo, pero no tiene script de ataque (`c_weapon_boomerang`) implementado todavía.

### `oL_power_spin` — Desbloqueo Spin *(RoomL)*
Igual que el anterior, agrega `"Spin"` al array `weapon_slots`.

> **Nota:** el arma Spin tampoco tiene script de ataque implementado actualmente.

### Obtención de power-ups

| Fuente | Power-Up(s) posibles | Probabilidades |
|---|---|---|
| `o_enemy_pow` (al morir por HP) | `o_power_plus` (45%), `o_power_homing` (25%), `o_power_overdrive` (12%), ninguno (18%) | Aleatorio con `irandom_range` |
| `o_enemy_slow` (al morir por HP) | `o_power_homing` | 5% de probabilidad (`drop_chance = 5`) |

---

## 10. Enemigos

Todos los enemigos que pueden recibir daño son instancias hijas de `o_enemy_body`. Este objeto padre centraliza:
- La recepción de daño por colisión con `o_att` y `o_standard_slash`.
- La destrucción automática cuando `hp <= 0`.
- La notificación al spawner cuando muere (`spawner_id.alive_count--`).
- El incremento del contador global `kills_since_last_portal`.
- La lógica de desbloqueo de armas al morir (Bomb en RoomL, Hook tras 5 kills en RoomL).

### Enemigos de `RoomK`

#### `o_enemy_fast` — Kamikaze
Enemigo suicida de alto daño y velocidad. Selecciona aleatoriamente una de tres rutas predefinidas (`path_kamikaze_1`, `path_kamikaze_2`, `path_kamikaze_3`) y las recorre a velocidad 15 px/step. Al colisionar con el jugador inflige 30 de daño y se destruye. HP: 10.

#### `o_enemy_slow` — Tirador táctico
Opera con una máquina de tres estados:
1. **`enter`:** avanza desde el borde derecho hasta una posición objetivo (`room_width - 520`) a velocidad 5 px/step.
2. **`fight`:** dispara misiles teledirigidos (`o_enemy_shoot_hom`, velocidad 15) cada ~1.5 segundos (`reloadSpeed = 90`). Permanece en combate durante 6 segundos (`fight_t = 6 * room_speed`).
3. **`escape`:** se retira hacia la izquierda con aceleración progresiva (de 5 hasta 9 px/step), hasta salir de pantalla. HP: 30, daño por contacto: 10.

Al morir por HP tiene un 5% de probabilidad de soltar `o_power_homing`.

#### `o_enemy_laser` — Artillería de rayo
Enemigo estático que opera en cuatro estados cíclicos:
1. **`idle`:** espera 1.5 segundos antes de iniciar la secuencia de ataque.
2. **`aiming`:** durante 0.75 segundos traza una guía punteada roja intermitente (largo 1600 px) hacia el jugador, actualizando la dirección en tiempo real.
3. **`firing`:** activa el rayo azul (largo 3000 px) durante 2 segundos. Cada 0.25 segundos verifica con `collision_line` si el rayo toca al jugador e inflige 5 de daño por tick.
4. **`cooldown`:** espera 2.5 segundos antes de reiniciar el ciclo.

HP: 25. Al ser eliminado, desbloquea el arma **Bomb** para el jugador en RoomL.

#### `o_enemy_pow` — Proveedor de power-ups
Enemigo de baja amenaza (HP: 20, daño: 10) que se mueve siguiendo una de dos rutas predefinidas (`path_pow_1`, `path_pow_2`) con un efecto de balanceo visual (oscilación del ángulo de imagen mediante `sin(tiempo)`). Al morir por daño, ejecuta un cálculo probabilístico para soltar un power-up según las probabilidades indicadas en la sección anterior.

### Enemigos de `RoomL`

#### `o_enemyL_fast` — Kamikaze (variante RoomL)
Hereda el comportamiento de `o_enemy_fast`. Tiene su propio tipo de objeto para diferenciarse visualmente y en los spawners de RoomL. No tiene código personalizado adicional en sus eventos.

#### `o_enemyL_slow` — Tirador táctico (variante RoomL)
Hereda el comportamiento completo de `o_enemy_slow`. La única diferencia es que `drop_chance = 0`, por lo que nunca suelta power-ups.

### Enemigos de `RoomS`

#### `o_enemyS_slow` — Tirador en estrella
Variante del tirador táctico con comportamiento modificado:
1. **`enter`:** avanza hasta su posición objetivo.
2. **`fight`:** dispara 10 proyectiles en ráfaga radial distribuidos a 360° (separados 36° entre sí), con un desplazamiento angular aleatorio de hasta 35° por ráfaga. Velocidad por proyectil: 6 px/step.
3. **`escape`:** se retira tras completar exactamente 3 ráfagas (`max_shots = 3`). No usa el temporizador de huida del padre; lo controla por conteo de disparos.

No suelta power-ups (`drop_chance = 0`).

#### `o_enemyS_spread` — Lanzador de orbes
Avanza desde fuera de pantalla hasta una posición objetivo y entra en estado de combate (`fight`). Dispara proyectiles de tipo `o_enemyS_orb` apuntando al jugador con recarga de 100 steps. HP: 20, daño por contacto: 10.

**`o_enemyS_orb`:** proyectil que viaja hasta 450 px, luego se detiene (estado `"armed"`) y tras 1.5 segundos explota con radio de 90 px y 20 de daño. La explosión puede dañar al jugador si está en el radio.

#### `o_enemyS_path` — Línea de daño cruzado
Enemigo que atraviesa toda la pantalla de forma lineal. Al crearse, elige aleatoriamente uno de tres patrones de desplazamiento:
- **Horizontal:** de izquierda a derecha o de derecha a izquierda.
- **Vertical:** de arriba a abajo o de abajo a arriba.
- **Diagonal:** uno de cuatro ángulos de esquina.

Deja un **rastro de daño visual** (línea punteada roja semitransparente) que permanece activo durante 3 segundos tras el paso del enemigo. Tanto el contacto directo (20 de daño) como el rastro (8 de daño cada 0.25 s) pueden herir al jugador. Además, mientras se desplaza, dispara misiles teledirigidos cada 70 steps con recarga automática. HP: 40.

---

## 11. El jefe final (`o_enemy_boss`)

El jefe es el encuentro culminante de cada sala y adapta su comportamiento según la sala en la que se instancie.

### Estadísticas

| Sala | HP máximo | Daño por contacto |
|---|---|---|
| `RoomK` | 250 | 20 |
| `RoomL` | 2500 (sprite diferente: `s_final_boss_1`) | 20 |
| `RoomS` | 250 | 20 |

### Fases de movimiento

1. **`enter`:** el jefe aparece fuera del borde derecho y avanza horizontalmente hacia `room_width - 600` a velocidad 1.5 px/step. No ataca durante esta fase.
2. **`fight`:** una vez posicionado, oscila verticalmente entre los márgenes de la sala (y < 96 / y > room_height - 96) a velocidad 4 px/step, rebotando al llegar a los bordes.

### Patrones de ataque por sala

#### En `RoomK`
Disparos en abanico radial cada 2 segundos: 10 proyectiles teledirigidos (`o_enemy_shoot_hom`) separados 14° entre sí, centrados en la dirección al jugador. Velocidad 20 px/step, daño 25.

#### En `RoomL`
Alterna entre dos patrones en ciclo `shoot_phase` (0 → 1 → 0 → 1…):
- **Fase 0 (homing):** igual que en RoomK: 10 proyectiles en abanico (12° de separación), velocidad 20, daño 25.
- **Fase 1 (láser):** activa el sistema de láser integrado. Apunta durante 0.75 s (guía punteada) y dispara durante 2 s (5 de daño por tick cada 0.25 s). Espera 5 segundos antes del siguiente ataque.

#### En `RoomS`
Rota entre tres fases en ciclo (0 → 1 → 2 → 0…):
- **Fase 0 (homing simple):** un solo misil teledirigido, velocidad 12.
- **Fase 1 (láser):** igual que en RoomL.
- **Fase 2 (orbe):** lanza un `o_boss_orb` que viaja 300 px y explota con radio 120 px y 30 de daño.

### Sistema de láser integrado

El jefe incorpora un sistema de láser propio (no depende de `o_enemy_laser`):
- **Estado `aiming`** (45 steps): traza una guía punteada roja intermitente, actualizando la dirección al jugador en tiempo real.
- **Estado `firing`** (120 steps): dibuja un rayo azul de 3000 px de largo. Cada 15 steps verifica con `collision_line` si impacta al jugador e inflige 5 de daño.

### Invocación de esbirros (minions)

Cada 8 segundos durante la fase de combate, el jefe invoca 2 enemigos de tipo rápido desde el borde derecho de la pantalla:
- En `RoomK`: 2 instancias de `o_enemy_fast`.
- En `RoomL`: 2 instancias de `o_enemyL_fast`.
- En `RoomS`: la invocación de minions está **deshabilitada** (código comentado).

### Sistema de recuperación (vampirismo)

Cada vez que el jugador muere durante el combate, el jefe **recupera 100 de HP** (hasta el máximo). El jefe monitorea `o_player.deaths` y calcula la diferencia respecto al valor registrado en `last_deaths` para aplicar la curación correctamente incluso con múltiples muertes consecutivas.

### Barra de salud

Durante la fase `fight`, el jefe muestra una barra de vida vertical en el lado derecho de la pantalla (`room_width - 60`). Se dibuja con un fondo gris (vida perdida), un rectángulo rojo (vida actual que crece desde abajo) y un marco blanco. La altura de la barra llena es proporcional a `hp / hpMax`.

### Al ser derrotado

1. Se destruyen todos los `o_enemy_manager` activos.
2. Se crea un portal permanente (`alarm[0] = -1`) en la posición del jefe:
   - RoomK → portal a `RoomL`
   - RoomL → portal a `RoomS`
   - Otras salas → `o_player.alarm[11]` con 4 segundos de retraso para ir a `RoomVEnd`

---

## 12. Sistemas gestores

### `o_game_manager` — Gestor de nivel

Objeto presente en `RoomK` y `RoomL`. Administra:
- El **temporizador del jefe** (`game_timer` acumulado en steps, disparador a `boss_time = 60 * room_speed`).
- La **penalización por muerte**: cada vez que el jugador muere, `boss_time` aumenta en `15 * room_speed` (15 segundos), retrasando la aparición del jefe.
- La **eliminación de spawners** al momento de aparecer el jefe.
- La restricción del arma Homing en `RoomK` al aparecer el jefe.
- El texto en pantalla que muestra la cuenta regresiva `"Jefe en: Xs"` (visible solo cuando el jefe no ha aparecido aún).

### `o_enemy_manager` — Spawner de enemigos

Generador reutilizable configurable por instancia desde el código de creación de cada sala. Sus parámetros clave:

| Variable | Valor por defecto | Descripción |
|---|---|---|
| `enemy_type` | `o_enemy_fast` | Tipo de enemigo a generar |
| `spawn_types` | `[]` | Lista de tipos para selección aleatoria (si no está vacía) |
| `spawn_x` | 1925 | Posición X base de aparición |
| `spawn_x_jitter` | 120 | Variación aleatoria horizontal |
| `spawn_check_time` | 60 steps | Intervalo base entre verificaciones |
| `spawn_variance` | 45 steps | Variación aleatoria del intervalo |
| `max_alive` | 1 | Máximo de enemigos simultáneos de este spawner |

Al crear un enemigo, le asigna su propio `id` como `spawner_id`. Cuando el enemigo muere, notifica al spawner decrementando `alive_count`, permitiendo que el ciclo continúe.

### `o_portal` — Portal de transición

Al colisionar con el jugador, navega a la sala almacenada en `target_room`. Si el destino es `RoomL`, establece `global.weapon_override = "Slash"` para que el jugador empiece esa sala con el arma correcta. Por defecto el portal se destruye a los 5 segundos (`alarm[0] = 5 * room_speed`); el jefe lo establece como permanente (`alarm[0] = -1`).

---

## 13. Interfaz de usuario (HUD)

### Indicador de vida (corazones)

Dibujado en la capa GUI del jugador (`Draw_64`). Muestra 6 corazones en la esquina superior izquierda. Cada corazón representa ~16.67 HP. Los estados posibles por corazón:
- **Lleno** (`s_heart_full`): el segmento tiene HP completo.
- **Medio** (`s_heart_half`): el segmento tiene HP parcial.
- **Vacío** (`s_heart_empty`): el segmento está agotado.

### Cuenta regresiva al jefe

El `o_game_manager` dibuja en el centro superior de la GUI el texto `"Jefe en: Xs"` donde X son los segundos restantes. El texto desaparece cuando el jefe aparece.

### Barra de vida del jefe

Dibujada en el propio evento Draw del jefe, no en la GUI. Aparece únicamente durante la fase `fight`, en el margen derecho de la sala.

### Menú principal

Gestionado por `o_menu_controller`. Usa texto y rectángulos simples (placeholder) para los botones JUGAR y SALIR. Los comentarios en el código indican que estos elementos están diseñados para ser reemplazados por sprites en el futuro.

---

## 14. Scripts globales

### `c_player_take_damage(amount)`
Función universal de daño al jugador. Efectos al recibir impacto:
- Si `invuln_timer > 0`: el golpe se ignora completamente.
- Resta `amount` a `hp`.
- Activa `invuln_timer = invuln_duration` (60 steps de invulnerabilidad).
- Si el arma era `"Homing"`, la degrada a `"Standard"`.
- Reduce `powlvl` en 1, hasta un mínimo de 1.

### `c_bomb_explode(_x, _y, _radius, _dmg)`
Explosión radial que afecta a todas las instancias de `o_enemy_body` y `o_enemy_boss` en el radio especificado mediante `point_distance`. También aplica daño fijo de **15 al jugador** si está dentro del radio (daño amistoso).

### `c_player_register_parry()`
Función de registro de parry. Incrementa `parry_charge` en `parry_charge_per_hit` hasta el máximo `parry_charge_max`. Al llegar al máximo, activa la bandera `charged_shot_ready = true`. También otorga 10 frames adicionales de invulnerabilidad al conectar el parry. Las variables `parry_charge`, `parry_charge_per_hit`, `parry_charge_max` y `charged_shot_ready` están implementadas en el script pero aún no inicializadas en el `Create` del jugador.

### `c_unlock_weapon(_name)`
Agrega un arma al array `weapon_slots` del jugador. Antes de insertarla verifica que no exista ya en el array (usando un bucle de búsqueda), evitando duplicados.

---

## 15. Interacciones entre sistemas

```
o_game_manager
    ↳ monitorea o_player.deaths → penaliza boss_time
    ↳ al cumplir boss_time → destruye o_enemy_manager(s) → instancia o_enemy_boss
    ↳ en RoomK: quita arma Homing al jugador si la tiene

o_enemy_body (padre de todos los enemigos destructibles)
    ↳ al destruirse → notifica a spawner_id (o_enemy_manager.alive_count--)
    ↳ al destruirse → global.kills_since_last_portal++
    ↳ al destruirse en RoomL → incrementa global.roomL_kills
    ↳ si roomL_kills >= 5 → desbloquea "Hook" en weapon_slots del jugador
    ↳ si era o_enemy_laser → desbloquea "Bomb" en weapon_slots del jugador

o_enemy_boss
    ↳ monitorea o_player.deaths → cura 100 HP por muerte del jugador
    ↳ al destruirse → destruye todos los o_enemy_manager
    ↳ al destruirse → crea o_portal con destino según la sala

o_power_overdrive → cambia weapon a "Spread", overdrive_shots_left = 5
    ↳ weapon == "Homing" → pending_weapon = "Homing"
    ↳ al agotar cargas → weapon = pending_weapon (o "Standard" si vacío)

o_power_homing → cambia weapon a "Homing"
    ↳ si weapon == "Spread" → pending_weapon = "Homing" (no reemplaza, queda en cola)

c_player_take_damage()
    ↳ si weapon == "Homing" → weapon = "Standard"
    ↳ powlvl = max(powlvl - 1, 1)

o_portal (target_room == RoomL) → global.weapon_override = "Slash"
    ↳ o_player Create → lee global.weapon_override si existe

o_bomb (estado "stuck") → sigue al target; si target muere → o_bomb se destruye
o_bomb (detonación) → c_bomb_explode() → daña enemigos + jugador en radio
```

---

## 16. Estado actual del proyecto

El proyecto es un prototipo funcional y jugable con las siguientes características operativas:

- ✅ Sistema de movimiento con dash, límites de pantalla y soporte dual teclado/gamepad
- ✅ Sistema de combate en RoomK (Standard, Homing, Spread/Overdrive)
- ✅ Sistema de combate en RoomL (Slash, Hook, Bomb) con desbloqueo progresivo
- ✅ Jefe final con múltiples patrones de ataque por sala y sistema de vampirismo
- ✅ Enemigos diferenciados por sala con comportamientos variados
- ✅ Sistema de power-ups con lógica de cola para compatibilidad entre armas
- ✅ HUD de corazones, cuenta regresiva del jefe y barra de vida del jefe
- ✅ Sistema de spawners configurables por instancia
- ✅ Portales de transición entre salas con desbloqueo por derrota del jefe
- ✅ Soporte completo para gamepad Xbox One con detección automática
- ⚠️ `RoomS` tiene enemigos y spawners funcionales, pero la sala está incompleta en comparación con RoomK y RoomL
- ⚠️ `oL_power_boomerang` y `oL_power_spin` desbloquean armas en el inventario, pero no existe implementación de ataque para esas armas
- ⚠️ El sistema de parry (`c_player_register_parry`, `c_weapon_bucket`) está implementado como scripts pero no conectado al flujo de juego
- ⚠️ La pantalla de muerte del jugador (`is_dead`) tiene su UI comentada en el código

---

## 17. Funcionalidades pendientes

Las siguientes características están definidas en el código (comentarios `// TODO`, código comentado o variables sin inicializar), pero aún no están completamente implementadas:

| Funcionalidad | Estado | Ubicación |
|---|---|---|
| **Arma Boomerang** | Solo desbloqueo, sin lógica de ataque | `oL_power_boomerang`, `weapon_slots` |
| **Arma Spin** | Solo desbloqueo, sin lógica de ataque | `oL_power_spin`, `weapon_slots` |
| **Sistema de Parry / Absorber** | Script implementado, no conectado al jugador | `c_player_register_parry`, `RT` gamepad |
| **Arma Bucket (cargada por parry)** | Script implementado, variables sin inicializar | `c_weapon_bucket`, `c_player_register_parry` |
| **Poder Final del jugador** | Solo detectado por input, sin lógica | `Step_0.gml` (LT gamepad) |
| **Mecánica extra (D-Pad ↓)** | Solo detectado por input, sin lógica | `Step_0.gml` |
| **Pantalla de muerte** | UI comentada en `Draw_64.gml` | `o_player/Draw_64.gml` |
| **Minions en RoomS** | Código comentado en el boss | `o_enemy_boss/Step_0.gml` |
| **RoomT** | Referenciada en el código pero no definida como sala activa | Referencias en `Step_0.gml` del jugador |
| **Título del menú** | Texto placeholder (`"Titulo PlaceHolder"`) | `o_menu_controller` |

---

*Proyecto desarrollado con GameMaker. Para abrir el proyecto, utilizar el archivo `Top Down Shooter.yyp` desde GameMaker IDE.*
