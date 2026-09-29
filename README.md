# 🎮 Top Down Shooter

> Proyecto de videojuego 2D top-down desarrollado en **GameMaker (GML)**. Presenta un jugador que atraviesa tres niveles de dificultad creciente, cada uno con su propio conjunto de armas, enemigos y un jefe final que escala en HP y ataques por sala.

---

## Índice

1. [Descripción general](#1-descripción-general)
2. [Flujo de juego](#2-flujo-de-juego)
3. [Tecnologías y herramientas](#3-tecnologías-y-herramientas)
4. [Estructura del proyecto](#4-estructura-del-proyecto)
5. [Salas (Rooms)](#5-salas-rooms)
6. [Jugador (o_player)](#6-jugador-o_player)
7. [Sistema de armas](#7-sistema-de-armas)
8. [Sistema de power-ups](#8-sistema-de-power-ups)
9. [Enemigos por sala](#9-enemigos-por-sala)
10. [Jefe final (o_enemy_boss)](#10-jefe-final-o_enemy_boss)
11. [Sistema de portal y progresión](#11-sistema-de-portal-y-progresión)
12. [Managers y objetos de control](#12-managers-y-objetos-de-control)
13. [Sistema de audio (o_sound)](#13-sistema-de-audio-o_sound)
14. [Rutas predefinidas (Paths)](#14-rutas-predefinidas-paths)
15. [Scripts reutilizables](#15-scripts-reutilizables)
16. [Sprites](#16-sprites)
17. [Controles](#17-controles)
18. [Variables globales](#18-variables-globales-relevantes)

---

## 1. Descripción general

Top Down Shooter es un juego de acción 2D en perspectiva cenital donde el jugador:

- Navega tres salas de combate (`RoomK` → `RoomL` → `RoomS`) con dificultad y mecánicas distintas.
- Enfrenta oleadas de enemigos que spawnean desde los bordes de la pantalla.
- Acumula power-ups, desbloquea armas y activa habilidades especiales.
- Combate un **jefe final** que aparece a los **60 segundos** de comenzar cada sala (con penalización de +15 seg por cada muerte).
- Al derrotar al jefe, un portal lo transporta a la siguiente sala (o a la pantalla de fin si fue la última).

El juego lleva un contador global de muertes (`global.total_deaths`) y de pasadas completadas (`global.pass`) que persisten entre partidas de la misma sesión.

---

## 2. Flujo de juego

```
RoomIMenu
    │ (cualquier input)
    ▼
RoomJTutorial
    │ (cualquier input)
    ▼
RoomK ──[boss derrotado]──► portal ──► RoomL ──[boss derrotado]──► portal ──► RoomS ──[boss derrotado]──► portal ──► RoomVEnd
                                                                                                                            │ (canción termina + cualquier input)
                                                                                                                            ▼
                                                                                                                      RoomIMenu (+1 a global.pass)
```

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
├── scripts/          # Scripts reutilizables (armas, daño, desbloqueos, parry)
├── rooms/            # Salas del juego (menú, tutorial, niveles, fin)
├── sprites/          # Gráficos del jugador, enemigos, fondos, UI
├── sounds/           # Recursos de audio (música por sala)
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
| **Managers** | `o_game_manager`, `o_enemy_manager`, `o_menu_controller`, `o_tutorial_controller`, `o_sound` |
| **Boss** | `o_enemy_boss` |
| **Enemigos RoomK** | `o_enemy_slow`, `o_enemy_fast`, `o_enemy_pow`, `o_enemy_laser` |
| **Enemigos RoomL** | `o_enemyL_slow`, `o_enemyL_fast` |
| **Enemigos RoomS** | `o_enemyS_slow`, `o_enemyS_path`, `o_enemyS_spread`, `o_enemyS_orb`, `o_enemyS_path_trail` |
| **Clase padre** | `o_enemy_body`, `o_enemy` |
| **Proyectiles jugador** | `o_standard_shot/_2/_3`, `o_homing_shot/_2/_3`, `o_spread_shot/_2/_3`, `o_standard_slash`, `o_hook_shot`, `o_bomb`, `o_shot` |
| **Proyectiles enemigo** | `o_enemy_att`, `o_enemy_shoot_hom`, `o_boss_orb`, `o_att` |
| **Power-ups** | `o_power_plus`, `o_power_homing`, `o_power_overdrive`, `oL_power_boomerang`, `oL_power_spin`, `o_pwr` |
| **Otros** | `o_portal`, `o_ending_title`, `o_kirby_ending_umbrella` |

---

## 5. Salas (Rooms)

| Sala | Descripción |
|---|---|
| `RoomIMenu` | Menú principal. Cualquier input inicia la partida (resetea `global.total_deaths`). |
| `RoomJTutorial` | Tutorial que muestra los controles. Cualquier input avanza a `RoomK`. |
| `RoomK` | **Nivel 1** — Armas de disparo horizontal (Standard, Spread, Homing). Boss con 1000 HP. |
| `RoomL` | **Nivel 2** — Armas cuerpo a cuerpo y de área (Slash, Hook, Bomb). Boss con 2500 HP + láser alternado. |
| `RoomS` | **Nivel 3** — Mecánica de parry y disparo de carga (Bucket). Boss con 3500 HP + 3 fases rotativas. |
| `RoomVEnd` | Pantalla de fin con animación de Kirby y créditos. Retorna al menú al terminar la canción. |

---

## 6. Jugador (`o_player`)

### Stats base

| Variable | Valor | Descripción |
|---|---|---|
| `move_speed` | 9 | Velocidad de movimiento normal |
| `max_hp` | 100 | Vida máxima |
| `total_hearts` | 6 | Corazones en la UI (cada uno ≈ 16.67 HP) |
| `dash_speed` | 20 | Velocidad durante el dash |
| `dash_duration` | 12 frames | Duración del dash |
| `dash_cooldown` | 30 frames | Cooldown entre dashes |
| `invuln_duration` | 60 frames | Iframes tras recibir daño |
| `dash_iframe_extra` | 15 frames | Iframes extra al terminar el dash |
| `attack_cooldown` | 20 frames | Cooldown de ataque general |
| `reloadSpeed` | 15 frames | Cooldown de disparo (alarma) |
| `powlvl` | 1 (máx 3) | Nivel de poder actual |
| `powerup_duration` | 600 frames (10s) | Duración de power-ups |

### Sistema de vidas y respawn

- El HUD muestra **6 corazones** (lleno / medio / vacío) según el HP actual.
- Al llegar a 0 HP: `is_dead = true`, el jugador se oculta (mueve a `y - 2000`) y `alarm[1]` activa el **respawn en 1 segundo**.
- Al respawnear: HP restaurado, `powlvl` reiniciado a 1, posición en (64, 576).
- Cada muerte suma 1 a `deaths` (local) y a `global.total_deaths`.
- Cada muerte activa penalización en el boss: `boss_time += 15 * room_speed` (+15 segundos).

### Sistema de dash

- `I` (teclado) / `RB` (gamepad) activan el dash.
- Si no hay dirección de movimiento activa, el dash se realiza hacia **arriba** por defecto.
- Durante el dash: el jugador es **invulnerable** (`invuln_timer = dash_duration + dash_iframe_extra`).
- Cooldown de 30 frames entre dashes. El jugador no puede morir durante un dash.

### Sistema de parry (exclusivo `RoomS`)

| Variable | Valor | Descripción |
|---|---|---|
| `parry_duration` | 14 frames | Ventana activa de parry |
| `parry_cooldown` | 45 frames | Cooldown entre parries |
| `parry_charge_max` | 100 | Carga máxima de la barra |
| `parry_charge_per_hit` | 20 | Carga por proyectil absorbido |

- `O` (teclado) / `RT` (gamepad) activan el parry.
- Cada proyectil enemigo absorbido durante la ventana activa añade `+20` a la barra de carga.
- Al llegar al máximo (`charged_shot_ready = true`) → disponible el disparo de balde (`c_weapon_bucket`).
- La barra se dibuja en la GUI: fondo oscuro → relleno rosa (en carga) → dorado (lista para disparar).
- Muestra texto: `"X/100"` o `"¡DISPARO CARGADO LISTO! (J)"`.

### Facing y sprites por sala

| Sala | Sprite |
|---|---|
| `RoomK` | `s_player_1` |
| `RoomL` | `s_player_2` |
| `RoomS` | `s_player_3` |

El `facing` (1 = derecha, -1 = izquierda) controla el `image_xscale`. En `RoomK` y `RoomS` el facing no cambia con el movimiento.

---

## 7. Sistema de armas

El arma activa depende de la sala actual. En `RoomL` existe un inventario rotativo de armas desbloqueadas.

### Armas de `RoomK`

| Arma | Script | Descripción |
|---|---|---|
| **Standard** | `c_weapon_standard(powlvl)` | Disparo recto. 3 niveles de poder (`o_standard_shot`, `_2`, `_3`). |
| **Spread** (Overdrive) | `c_weapon_spread(powlvl)` | Abanico de 10 proyectiles entre -60° y +60°. Dura **5 disparos** y revierte a Standard (o Homing si estaba en cola). |
| **Homing** | `c_weapon_homing(powlvl)` | Proyectil teledirigido al enemigo más cercano. 3 niveles. **Se pierde al recibir daño.** |

> **Nota:** Al aparecer el boss en `RoomK`, si el jugador tenía Homing activo, el arma se resetea a Standard automáticamente.

### Armas de `RoomL` (inventario rotativo)

Gestionadas por `weapon_slots[]`. Se cambia con `K` / D-Pad Derecho.

| Arma | Script | Desbloqueo | Descripción |
|---|---|---|---|
| **Slash** | `c_weapon_slash()` | Disponible desde el inicio | Espadazo que crea un hitbox (`o_standard_slash`) a 80px del jugador según el facing. Animación con `s_att_sword`. |
| **Hook** | `c_weapon_hook()` | 5 kills en `RoomL` | Látigo (`o_hook_shot`) que se extiende 340px, luego retrae, aplicando knockback de 24px a los enemigos golpeados. |
| **Bomb** | `c_weapon_bomb()` | Matar un `o_enemy_laser` | 1er toque: lanza bomba (`o_bomb`). 2do toque: la detona. Explosión daña enemigos **y** al jugador dentro del radio. |
| **Boomerang** | *(en progreso)* | Power-up `oL_power_boomerang` | Se desbloquea recogiendo el power-up correspondiente en sala L. |
| **Spin** | *(en progreso)* | Power-up `oL_power_spin` | Se desbloquea recogiendo el power-up correspondiente en sala L. |

### Armas de `RoomS`

| Arma | Script | Descripción |
|---|---|---|
| **Bucket** (Balde) | `c_weapon_bucket(x, y, facing)` | Dispara 10 proyectiles en abanico de 35° ligeramente elevado. Daño y tamaño escalan con la carga del parry (`_charge_ratio`). **Consume toda la barra.** Requiere mínimo 20 de carga. |

---

## 8. Sistema de power-ups

### Power-ups de `RoomK` (soltados por `o_enemy_pow` al morir)

| Power-up | Probabilidad | Efecto |
|---|---|---|
| `o_power_plus` | 45% | Aumenta `powlvl` en 1 (máx 3). |
| `o_power_homing` | 25% | Cambia el arma a Homing. Si hay Overdrive activo, queda en `pending_weapon`. |
| `o_power_overdrive` | 12% | Activa Spread por 5 disparos. Si había Homing, lo encola en `pending_weapon`. |
| *(nada)* | 18% | Sin drop. |

### Power-ups de `RoomL` (en sala)

| Power-up | Efecto |
|---|---|
| `oL_power_boomerang` | Desbloquea el arma "Boomerang" en `weapon_slots[]`. |
| `oL_power_spin` | Desbloquea el arma "Spin" en `weapon_slots[]`. |

---

## 9. Enemigos por sala

### Clase padre: `o_enemy_body`

Todos los enemigos heredan de `o_enemy_body`. Al destruirse cualquier enemigo que lo tenga como padre:
- Avisa al `o_enemy_manager` y libera un slot (`alive_count--`).
- Incrementa `global.kills_since_last_portal`.
- Ejecuta lógica de desbloqueo específica de la sala.

### Enemigos de `RoomK`

| Objeto | Descripción | HP | Daño |
|---|---|---|---|
| `o_enemy_slow` | Entra desde la derecha hacia el jugador y dispara proyectiles frontales. Drop chance 5%. | 30 | 10 |
| `o_enemy_fast` | Kamikaze veloz que embiste al jugador. Sin disparo. | — | colisión |
| `o_enemy_pow` | Igual a `o_enemy_slow` pero con sistema de drop de power-ups. | 30 | 10 |
| `o_enemy_laser` | Entra desde un borde, apunta (línea punteada 45 frames) y dispara rayo (120 frames). Repite 2 veces y se retira. **Al morir desbloquea la Bomba en RoomL.** | 25 | 5/tick |

### Enemigos de `RoomL`

| Objeto | Descripción |
|---|---|
| `o_enemyL_slow` | Equivalente lento para la sala L. |
| `o_enemyL_fast` | Equivalente rápido para la sala L. También invocado por el boss. |

### Enemigos de `RoomS`

| Objeto | Descripción | HP | Daño |
|---|---|---|---|
| `o_enemyS_slow` | Versión lenta del nivel S. Invocado también por el boss. | — | — |
| `o_enemyS_path` | Atraviesa la pantalla en línea recta (horizontal / vertical / diagonal) desde cualquier borde. Deja un **rastro peligroso** (8 dmg/0.25s) y dispara proyectiles teledirigidos mientras se mueve. | 40 | 20 + rastro 8/tick |
| `o_enemyS_spread` | Entra desde el borde y dispara un abanico de proyectiles al llegar a su posición objetivo. | 20 | 10 |
| `o_enemyS_orb` | Proyectil-enemigo: vuela hacia el jugador 450px, se detiene, explota tras 1.5s en radio de 90px. | — | 20 (área) |
| `o_enemyS_path_trail` | Rastro visual/dañino dejado por `o_enemyS_path`. | — | — |

---

## 10. Jefe final (`o_enemy_boss`)

### Stats por sala

| Sala | HP | Sprite |
|---|---|---|
| `RoomK` | 1 000 | `s_final_boss` |
| `RoomL` | 2 500 | `s_final_boss_1` |
| `RoomS` | 3 500 | `s_final_boss_2` |

### Mecánica de entrada

1. Aparece fuera de pantalla (derecha) al cumplirse `boss_time`.
2. Estado `"enter"`: se desplaza hacia `target_x = room_width - 600` a `vSpeed = 1.5` px/step.
3. Durante la entrada, hitbox desactivado (`mask_index = s_boss_no_hitbox`).
4. Al llegar, pasa a estado `"fight"`, hitbox se reactiva, primer disparo tras 1 segundo.

### Movimiento en combate

Oscilación vertical continua a `hSpeed = 4` px/step entre `y = 96` y `y = room_height - 96`.

### Barra de vida

Dibujada en el borde derecho de la pantalla (32px ancho, vertical, se llena de abajo hacia arriba). Visible solo en estado `"fight"`.

### Recuperación de vida por muerte del jugador

Cada vez que el jugador muere mientras el boss está activo:
```
boss.hp = min(hp + 500 × muertes_nuevas, hpMax)
```

### Fases de ataque

#### `RoomK` — Fase única

| Ataque | Descripción |
|---|---|
| **Spread homing** | 10 proyectiles (`o_enemy_shoot_hom`) en abanico de 14° apuntando al jugador. Cooldown: 2 segundos. |
| **Invocación** | Cada 8 segundos: 2× `o_enemy_fast`. |

#### `RoomL` — Alternancia 0 ↔ 1

| Fase | Ataque | Cooldown |
|---|---|---|
| 0 | **Spread homing**: 10 proyectiles, 12° de separación. | 2s |
| 1 | **Láser**: apuntado 0.75s (línea punteada roja parpadeante) → disparo 2s (rayo azul sólido, 5 dmg/0.25s). | 5s |
| — | **Invocación**: cada 8 segundos: 2× `o_enemyL_fast`. | — |

#### `RoomS` — Rotación 0 → 1 → 2 → 0

| Fase | Ataque | Cooldown |
|---|---|---|
| 0 | **Spread homing**: 10 proyectiles, 12° de separación. | 2s |
| 1 | **Láser**: igual que RoomL. | 5s |
| 2 | **Orbe** (`o_boss_orb`): proyectil explosivo, radio 120, 30 dmg. | 3s |
| — | **Invocación**: cada 8 segundos: 2× `o_enemyS_slow`. | — |

### Visuals del láser

- **Apuntando**: línea punteada roja, parpadeante (0.35/0.85 de alfa alternando cada 10 frames), largo 1600px.
- **Disparando**: rayo azul sólido, grosor 6px, largo 3000px.

### Al morir el boss

1. Destruye todos los `o_enemy_manager` activos.
2. Crea un `o_portal` permanente que lleva a la siguiente sala.
3. En `RoomS`, el portal lleva a `RoomVEnd`.

---

## 11. Sistema de portal y progresión

`o_portal` es el nexo entre salas. Su `target_room` se configura al crearlo:

| Portal creado en | Destino |
|---|---|
| `RoomK` (al matar boss) | `RoomL` |
| `RoomL` (al matar boss) | `RoomS` |
| `RoomS` (al matar boss) | `RoomVEnd` |

- Los portales creados por el boss son **permanentes** (`alarm[0] = -1`).
- `image_xscale = 2`, `image_yscale = 2`.
- Al tocarlos, el jugador cambia de sala. El arma activa se transfiere vía `global.weapon_override`.

---

## 12. Managers y objetos de control

### `o_game_manager`

Objeto persistente que controla el **timer del boss** y la lógica global:

| Variable | Valor | Descripción |
|---|---|---|
| `boss_time` | `60 × room_speed` | Tiempo hasta que aparece el boss (1 minuto) |
| `death_penalty` | `15 × room_speed` | Segundos extra por muerte del jugador |
| `global.pass` | 0 inicial | Partidas completadas |
| `global.total_deaths` | 0 inicial | Muertes totales en la sesión |

- Al cumplirse `boss_time`: destruye todos los spawners y crea `o_enemy_boss` en `room_width + 100, room_height / 2`.
- En `RoomK`, si el jugador tenía Homing al aparecer el boss, se resetea a Standard.

### `o_enemy_manager`

Spawner configurable de enemigos. Parámetros clave:

| Variable | Default | Descripción |
|---|---|---|
| `max_alive` | 1 | Cantidad máxima de enemigos simultáneos por spawner |
| `spawn_check_time` | 60 frames | Intervalo base de spawn |
| `spawn_variance` | ±45 frames | Variación aleatoria del intervalo |
| `spawn_types[]` | vacío | Lista de tipos a elegir al azar |
| `spawn_sides[]` | vacío | Lados válidos: `"left"`, `"top"`, `"right"` |
| `spawn_x` | 1925 | Posición X base de spawn |
| `spawn_x_jitter` | 120px | Variación horizontal del punto de spawn |

Cada enemigo creado recibe: `spawner_id`, `spawn_side`, `origin_x/y`, `target_x/y`.

### `o_menu_controller`

- En `RoomIMenu`: cualquier input → `RoomJTutorial` + resetea `global.total_deaths`.
- En `RoomVEnd`: detecta fin de canción (via `o_sound`) → cualquier input incrementa `global.pass` y vuelve al menú.

### `o_tutorial_controller` / `o_tutorial_splatoon` / `o_tutorial_zelda`

Controladores de la sala tutorial. Muestran instrucciones de diferentes estilos de juego.

---

## 13. Sistema de audio (`o_sound`)

Objeto **persistente** (`persistent = true`). Detecta cambios de sala en cada Step y para/inicia la pista:

| Sala | Pista | Loop |
|---|---|---|
| `RoomIMenu` / `RoomJTutorial` | `snd_menu_tutorial` | ✅ |
| `RoomK` | `snd_roomK` | ✅ |
| `RoomL` | `snd_roomL` | ✅ |
| `RoomS` | `snd_roomS` | ✅ |
| `RoomVEnd` | `snd_roomVEnd` | ❌ (fin de canción dispara transición) |

Pistas alternativas disponibles: `snd_roomK_1`, `snd_roomL_1`, `snd_roomS_1`.

---

## 14. Rutas predefinidas (Paths)

| Path | Uso |
|---|---|
| `path_kamikaze_1` | Trayectoria de enemigos kamikaze (variante 1) |
| `path_kamikaze_2` | Trayectoria de enemigos kamikaze (variante 2) |
| `path_kamikaze_3` | Trayectoria de enemigos kamikaze (variante 3) |
| `path_pow_1` | Ruta de potenciadores (variante 1) |
| `path_pow_2` | Ruta de potenciadores (variante 2) |
| `p_kirby_cayendo` | Animación de Kirby cayendo (pantalla de fin) |

---

## 15. Scripts reutilizables

| Script | Firma | Descripción |
|---|---|---|
| `c_weapon_standard` | `(powlvl)` | Crea `o_standard_shot` según nivel (1/2/3). |
| `c_weapon_spread` | `(powlvl)` | Crea 10 proyectiles en abanico de 120° (-60° a +60°). |
| `c_weapon_homing` | `(powlvl)` | Crea `o_homing_shot` teledirigido según nivel. |
| `c_weapon_slash` | `()` | Activa animación de espada y crea hitbox de slash. |
| `c_weapon_hook` | `()` | Crea el gancho (`o_hook_shot`) orientado al facing. |
| `c_weapon_bomb` | `()` | Lanza bomba (1er toque) o la detona (2do toque). |
| `c_weapon_bucket` | `(x, y, facing)` | Abanico de 10 balas escaladas por carga de parry. Resetea la barra. |
| `c_bomb_explode` | `(x, y, radius, dmg)` | Daño de área a `o_enemy_body`, `o_enemy_boss` y al jugador. |
| `c_player_take_damage` | `(amount)` | Aplica daño respetando iframes. Baja `powlvl` y resetea Homing al recibir daño. |
| `c_player_register_parry` | `()` | Suma carga de parry (+20). Activa `charged_shot_ready` al llegar al máximo. Da 10 iframes extra. |
| `c_unlock_weapon` | `(name)` | Agrega un arma al `weapon_slots[]` del jugador si no existe ya. |
| `c_any_input_pressed` | `()` | Devuelve `true` si se presionó cualquier tecla o botón de gamepad. |

---

## 16. Sprites

### Jugador

| Sprite | Uso |
|---|---|
| `s_player` | Base / genérico |
| `s_player_1` | Jugador en `RoomK` |
| `s_player_2` | Jugador en `RoomL` |
| `s_player_3` | Jugador en `RoomS` |
| `s_att_sword` | Animación de ataque con espada |
| `s_att_bucket` | Animación de ataque con balde |

### Enemigos

| Sprite | Uso |
|---|---|
| `s_enemy_1/2/3` | Enemigos genéricos variantes 1-3 |
| `s_enemy_slow` | Enemigo lento |
| `s_enemy_path` | Enemigo tipo path (`RoomS`) |
| `s_enemy_spread` | Enemigo spread (`RoomS`) |
| `sL_enemy_1/2/3` | Enemigos para sala L |
| `s_final_boss` | Boss en `RoomK` |
| `s_final_boss_1` | Boss en `RoomL` |
| `s_final_boss_2` | Boss en `RoomS` |
| `s_boss_no_hitbox` | Máscara vacía del boss durante la entrada |

### Proyectiles y UI

| Sprite | Uso |
|---|---|
| `s_standard_shot/_2/_3` | Proyectil estándar niveles 1-3 |
| `s_standard_att` | Hitbox de slash |
| `s_paint_shot` | Proyectil de pintura (RoomS) |
| `s_test_shoot` | Proyectil de prueba |
| `s_heart_full/_half/_empty` | Corazones de la UI de vida |
| `s_power_homing` | Ícono power-up Homing |
| `s_power_plus` | Ícono power-up Plus |
| `s_power_change` | Ícono de cambio de arma |
| `s_indicacion` | Indicación en pantalla |

### Fondos y menú

| Sprite | Uso |
|---|---|
| `s_fondo_menu` | Fondo del menú principal |
| `s_titulo` | Logo/título del juego |
| `backgroundKirby1` | Fondo nivel Kirby |
| `cielo` | Capa de cielo (parallax) |
| `nubesCerca/nubesLejos` | Nubes en dos planos de profundidad |
| `arbolesSecundarios` | Árboles de fondo |
| `pinosPrincipales_cesped_rocas` | Elementos de primer plano |
| `monta_a36` | Montañas de fondo |
| `s_florMaravilla` | Flores decorativas |
| `s_tutorial_principal` | Imagen principal del tutorial |
| `s_tutorial_splatoon` | Sección tutorial estilo Splatoon |
| `s_tutorial_zelda_1` | Sección tutorial estilo Zelda |
| `s_ending_title` | Título de la pantalla final |
| `s_kirby_ending_umbrella` | Kirby con paraguas (pantalla final) |
| `s_kirbySorpresa` | Kirby sorprendido |
| `fin` | Imagen de fin |

---

## 17. Controles

| Acción | Teclado | Gamepad (Xbox One) |
|---|---|---|
| Mover | `W` `A` `S` `D` | Left Stick |
| Atacar / Disparar | `J` | `B` (gp_face2) |
| Dash | `I` | `RB` (gp_shoulderr) |
| Cambiar arma (RoomL) | `K` | D-Pad Derecho (gp_padr) |
| Parry / Absorber (RoomS) | `O` | `RT` (gp_shoulderrb > 0.15) |
| Acción especial | — | `LT` (gp_shoulderlb > 0.15) |
| Acción extra | — | D-Pad Abajo (gp_padd) |

> El gamepad se detecta automáticamente al inicio (comprueba slots 0–3). Dead zone del stick: **0.1**.

---

## 18. Variables globales relevantes

| Variable | Descripción |
|---|---|
| `global.total_deaths` | Total de muertes acumuladas en la sesión |
| `global.pass` | Número de veces que se completó el juego |
| `global.roomL_kills` | Kills en `RoomL` (umbral 5 para desbloquear el Hook) |
| `global.kills_since_last_portal` | Kills desde el último portal |
| `global.weapon_override` | Arma con la que se inicia la sala siguiente |

---

*Proyecto en desarrollo activo — GameMaker (GML)*
