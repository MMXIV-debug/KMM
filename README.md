# Documentación Técnica del Proyecto: Top Down Shooter

Este documento constituye la referencia técnica exhaustiva del proyecto. Detalla la arquitectura, los sistemas, las mecánicas de juego y el comportamiento de la inteligencia artificial y de los objetos del entorno. Ha sido redactado con el propósito de facilitar la comprensión de la lógica interna y servir de base para futuros desarrollos o auditorías del código.

---

## 1. Arquitectura General y Sistemas
El juego implementa mecánicas de un "Top Down Shooter", estructurando la visualización y las colisiones en un entorno de vista superior, aunque ciertas interacciones y animaciones limitan el eje visual horizontal (variable `facing`). El proyecto consta de:
- **Salas (Rooms):** Gestión del flujo de juego mediante transiciones entre `RoomIMenu`, `RoomJTutorial`, `RoomK`, `RoomL`, `RoomS`, `RoomT`, y `RoomVEnd`.
- **Soporte de Múltiples Entradas (Multi-Input):** Sistema de control híbrido que admite tanto teclado como Gamepad (con mapeo de botones adaptado al estándar de Xbox One).
- **Sistema de Armamento:** Framework modular que permite la transición entre armas, el uso de habilidades especiales y el consumo de recursos (por ejemplo, munición limitada en el estado de "Overdrive").
- **Controlador de Flujo:** Gestores de estado (`Managers`) que administran los temporizadores para la aparición de jefes, cálculos de penalización, control de oleadas y eventos globales de la partida.

---

## 2. Entidad del Jugador (`o_player`)
Objeto central del proyecto encargado de procesar la entrada del usuario, administrar las físicas de movimiento y gestionar la lógica de combate.

### Atributos y Estado Inicial (Create)
- **Vitalidad:** Definida por `max_hp = 100`, con representación en una interfaz de corazones (`total_hearts = 6`). Maneja los ciclos de invulnerabilidad post-daño (`invuln_duration = 60`) y el registro histórico de muertes (`deaths`).
- **Movimiento:** La velocidad base está asignada a `move_speed = 9`. Incorpora una mecánica de evasión (Dash) que aplica un vector de impulso de `dash_speed = 20` durante `12` ciclos (steps), gobernada por un tiempo de recarga (cooldown) de `30` ciclos.
- **Sistema de Armamento:** La tasa de disparo es controlada por `attack_cooldown = 20`. El arsenal se almacena en el arreglo `weapon_slots`, permitiendo escalar el nivel de poder de los ataques (`powlvl`, máximo 3). El arma activa se almacena en `weapon` (por defecto "Standard"), pudiendo ser sobrescrita al inicio del nivel a través de `global.weapon_override`.
- **Gestión de Periféricos:** Para optimizar las lecturas analógicas del Gamepad, las presiones previas de los gatillos (LT/RT) se almacenan en `lt_prev` y `rt_prev`, permitiendo interpretar las presiones sostenidas como eventos singulares.

### Lógica de Ejecución (Step)
1. **Verificación de Estado Vital:** Si los puntos de salud descienden a cero, se altera la bandera `is_dead` a verdadera, se incrementa el registro de muertes, y se desplaza la entidad visualmente fuera de cámara (`y -= 2000`). Posteriormente, se activa una alarma temporal para la reaparición (respawn).
2. **Procesamiento de Entradas:** Unifica la lógica de lectura tanto para teclado (WASD, I, J, K) como para el Gamepad. Habilita acciones extendidas a través de los gatillos analógicos si estos superan un umbral de presión del `15%`, gatillando habilidades definitivas o maniobras defensivas (Parry).
3. **Cinemática:** Calcula un vector normalizado (`dir_x`, `dir_y`) para obtener desplazamientos consistentes en ángulos diagonales. La orientación visual del sprite (`image_xscale`) se actualiza según la variable `facing`, con excepciones aplicadas en ciertas salas específicas (`RoomK`, `RoomS`, `RoomT`).
4. **Mecánica de Evasión (Dash):** Verifica el estado de los cooldowns y, de ser válidos, sobrescribe la velocidad de traslación utilizando la última dirección registrada por el jugador.
5. **Colisiones y Límites Espaciales:** Restringe las coordenadas posicionales de la entidad para asegurar que no pueda abandonar el perímetro de visión de la sala, empleando los `bounding_boxes` (bbox).
6. **Ejecución Ofensiva:** La lógica de instanciación de ataques difiere según la sala:
   - **En `RoomL`:** Se invoca la ejecución de funciones específicas para combate cuerpo a cuerpo y táctico ("Slash", "Hook", "Bomb").
   - **Resto de Salas:** Dispara proyectiles a distancia ("Standard", "Spread", "Homing"). El modo "Spread" consume una variable de municiones finitas (`overdrive_shots_left`), regresando automáticamente al arma anterior al vaciarse.

### Renderizado e Interfaz Gráfica (Draw / Draw GUI)
- **Feedback de Invulnerabilidad:** Utiliza el modo de mezcla aditiva (`gpu_set_blendmode(bm_add)`) para crear un efecto de destello (flashing) intermitente durante los ciclos en los que el jugador no puede recibir daño.
- **HUD Dinámico:** Renderiza la barra de vida utilizando segmentos (corazones). Calcula la proporción de salud correspondiente a cada segmento, dibujando independientemente si cada uno debe mostrarse lleno, a la mitad o vacío.

---

## 3. Gestores de Escenario y Controladores

### `o_game_manager`
- **Propósito:** Supervisar la progresión del nivel y dictar eventos globales (por ejemplo, los enfrentamientos contra jefes en `RoomK` y `RoomL`).
- **Sistema de Penalización:** Implementa una regla de riesgo/recompensa. Si el jugador muere repetidamente, el sistema detecta la diferencia entre `deaths` y `last_deaths`, añadiendo `15` segundos de espera adicionales (`death_penalty`) a la aparición del Jefe por cada defunción.
- **Intervención en Entorno:** Al cumplirse el temporizador del Jefe (`boss_time`), el sistema elimina todos los generadores de enemigos de la memoria, reduce el poder del jugador si posee misiles teledirigidos ("Homing"), e instancia la entidad del Jefe Final.

### `o_enemy_manager` (Generador / Spawner)
- **Lógica de Generación:** Verifica constantemente si el número de entidades enemigas instanciadas (`alive_count`) es menor al límite permitido (`max_alive`). En caso afirmativo, calcula coordenadas con cierto grado de aleatoriedad espacial (`spawn_x_jitter`) y crea un nuevo objeto enemigo.
- **Vinculación de Memoria:** Al instanciar un enemigo, le provee su propio ID (`spawner_id`). Esto permite que, al ser destruido, el enemigo reporte su muerte al gestor, habilitando el ciclo de generación continua.

### `o_menu_controller` y `o_tutorial_controller`
- Gestionan la navegación entre escenas iniciales utilizando cálculos espaciales basados en coordenadas rectangulares para los elementos de UI, interceptando los clics del mouse y dirigiéndolos hacia las funciones `room_goto`.

### `o_portal`
- Elemento de transición de escenario interactivo.
- Posee un contador de auto-destrucción de 5 segundos. Si el jugador no interactúa a tiempo, pierde la oportunidad de cambiar de zona. El Jefe Final tiene la capacidad de anular esta destrucción mediante la asignación de la alarma a un valor `-1`, dejando el portal activo permanentemente.

---

## 4. Estructura de Scripts de Combate

Para favorecer la modularidad, todas las mecánicas ofensivas han sido externalizadas en scripts individuales:

### Combate a Distancia (Proyectiles)
- **`c_weapon_standard(powlvl)`:** Instancia un objeto proyectil frontal básico y administra su variante en función del nivel de poder.
- **`c_weapon_spread(powlvl)`:** Implementa un bucle de iteración que, apoyado en interpolación lineal (`lerp`), distribuye equitativamente múltiples instancias de proyectiles en un ángulo cónico que abarca desde `-60` a `60` grados.
- **`c_weapon_homing(powlvl)`:** Genera misiles inteligentes autoguiados.

### Combate Físico / Táctico (`RoomL`)
- **`c_weapon_slash()`:** Produce un área de daño físico instanciada frente al jugador, aplicando un offset dependiente de su dirección visual.
- **`c_weapon_hook()`:** Inicializa la entidad del látigo de energía, responsable del control de masas.
- **`c_weapon_bomb()`:** Contiene una lógica dual para su botón de acción:
  - Presión primaria: Instancia el explosivo físico con físicas de inercia rectilínea.
  - Presión secundaria (si la bomba ya fue desplegada): Hace una llamada al script de explosión `c_bomb_explode()`.

### Sistemas Híbridos y Daño Global
- **`c_player_take_damage(amount)`:** Sustrae salud y resetea beneficios, actuando como método universal de penalización de daño. Desciende el nivel del poder activo y anula armas avanzadas si las hubiera.
- **`c_bomb_explode(_x, _y, _radius, _dmg)`:** Escanea un radio esférico en busca de colisiones matemáticas (utilizando `point_distance`). Afecta a cualquier enemigo, pero implementa adicionalmente daño a aliados (Friendly Fire), restando puntos de vida si el propio jugador está en el área de explosión.

---

## 5. Arsenal: Entidades de Proyectil y Ataque

### Munición Convencional
- **`o_standard_shot`, `o_spread_shot`:** Proyectiles con desplazamiento rectilíneo predecible. Destrucción automatizada al abandonar la zona segura de la cámara para prevenir fugas de memoria.
- **`o_homing_shot`:** A través de la función `instance_nearest`, localiza el objetivo más viable. En vez de realizar un seguimiento instantáneo, calcula la diferencia angular (`angle_difference`) y ajusta gradualmente su trayectoria según la variable limitante `turn_rate`, otorgando un movimiento parabólico realista.

### Lógica de Combate Cuerpo a Cuerpo
- **`o_standard_slash` (Corte Estándar):** El barrido dura `15` ciclos. Emplea la estructura de datos `ds_list` para registrar de manera unívoca los ID de los enemigos impactados, garantizando que el evento de daño se procese únicamente una vez por individuo afectado.
- **`o_hook_shot` (Látigo Energético):** Objeto dinámico con fases de estado: "Extend" (expansión del radio de colisión) y "Retract" (contracción de vuelta al emisor). 
  - Utiliza `collision_line_list` para calcular intersecciones a lo largo de su vector. 
  - Al registrar un impacto exitoso, aplica un algoritmo de retroceso inverso (Knockback negativo) utilizando `lengthdir_x/y` para arrastrar a las entidades afectadas hacia el punto de origen.

### Explosivo Táctico (`o_bomb`)
Gestiona una máquina de estados finitos ("flying", "stuck", "boom"):
- **Vuelo:** Sigue una trayectoria lineal hasta intersectar una entidad enemiga mediante `instance_place`.
- **Adherencia (Stuck):** Calcula el offset relativo entre su propio punto de contacto y las coordenadas cartesianas del enemigo (`off_x`, `off_y`). Durante este estado, sobrescribe sus coordenadas forzando un anclaje perfecto a la silueta del adversario.
- **Detonación (Boom):** Ejecuta una animación controlada por interpolación matemática de tamaño y canal alfa (Alpha Fading) previo a su destrucción definitiva.

---

## 6. Ecosistema de Inteligencia Artificial: Enemigos

Toda entidad destructible deriva del objeto padre `o_enemy_body`, el cual centraliza la lógica de recepción de daño, validación de muerte y la comunicación bidireccional con sus respectivos generadores (Spawners).

- **`o_enemy_pow`:** Entidad de baja amenaza. Su movimiento vertical está dictaminado por una función trigonométrica seno, generando un balanceo fluido. A su deceso, ejecuta un cálculo probabilístico (RNG) para instanciar diversos "Power-Ups".
- **`o_enemy_fast` (Kamikaze):** Prioriza la velocidad de embestida. Navega el nivel implementando un sistema de rutas de GameMaker (`paths`).
- **`o_enemy_slow` (Tirador Táctico):** Incorpora toma de decisiones basada en tiempos. Ingresa a la zona de conflicto, frena por completo, y descarga ráfagas de misiles a través de alarmas. Concluido su tiempo estipulado de combate (`fight_t`), altera su estado interno hacia "Escape", huyendo velozmente de la cámara.
- **`o_enemy_laser` (Artillería Pesada):** Entidad de altísimo riesgo que opera en cuatro fases estrictas:
  1. `idle`: Ciclo de preparación inactiva.
  2. `aiming`: Traza un vector de predicción visual intermitente para advertir al jugador de su línea de visión (Line of Sight).
  3. `firing`: Renderiza y activa el láser definitivo. El cálculo de impacto se rige bajo la mecánica temporal de `Ticks` (daño sostenido fraccionado cada cierto número de milisegundos a lo largo del `collision_line`).
  4. `cooldown`: Fase de sobrecalentamiento que impide ataques consecutivos inmediatos.

---

## 7. El Jefe Final (`o_enemy_boss`)

El pináculo del diseño de combate del juego, operando con rutinas condicionales que evalúan y adaptan su conjunto de reglas al entorno en el que es instanciado (Las salas `RoomK`, `RoomL` y `RoomS`).

### Estructura de Estados
- **Fase de Inserción (`enter`):** Desplazamiento interpolado desde fuera de los márgenes hasta un punto de anclaje predefinido.
- **Fase Ofensiva (`fight`):** Inicio de cálculos de oscilación de las coordenadas Y, empleando rebotes limitados. En este estado se habilitan todas las rutinas de ataque y sub-procesos.

### Patrones de Ataque Adaptativos
El comportamiento de agresión rota secuencialmente:
- **Ráfaga Radial:** Ejecuta cálculos matemáticos basados en ángulos de separación predefinidos para instanciar misiles (`o_enemy_shoot_hom`) en un patrón de propagación uniforme.
- **Láser Integrado:** Reutiliza de forma nativa la lógica del `o_enemy_laser`, forzando al controlador del jefe a interrumpir otras rutinas de fuego temporalmente para ejecutar la precisión direccional del haz destructivo.
- **Orbe Persecutorio (`o_boss_orb`):** Proyectil de alcance fijo que, al concluir su recorrido límite, emite un pulso perjudicial en un área estipulada.

### Generación de Esbirros (Minions)
El Jefe paraleliza una tarea temporal (cada 8 segundos) que efectúa instanciaciones inmediatas de súbditos de clase rápida (`o_enemy_fast` o `o_enemyL_fast`), creando distractores tácticos en los laterales de la pantalla.

### Sistema de Recuperación (Vampirismo Táctico)
Implementa un diseño de penalización para prolongar el conflicto si el usuario falla. Monitorea continuamente la memoria del jugador evaluando `o_player.deaths > last_deaths`. En caso positivo, se aplica una regeneración sustancial sobre la barra de salud del jefe (`heal_on_kill = 100`), forzando al jugador a desarrollar pericia mecánica para vencerlo.

### Transición de Derrota y Feedback Visual
Al procesarse la destrucción de esta entidad, el sistema realiza una limpieza global (Garbage Collection conceptual) que remueve a todos los enemigos y generadores de la sala. Posterior a esto, se desbloquea un portal infinito en las coordenadas centrales. Su salud se renderiza asimétricamente en pantalla en forma de un medidor dinámico que utiliza reglas de tres para su llenado gráfico.

---

## 8. Elementos Adicionales y Mejoras Temporales (Power-Ups)

Los consumibles, al interaccionar con el `Bounding Box` del jugador, manipulan su inventario:
- **`o_power_plus`:** Incrementa secuencialmente el multiplicador base (hasta nivel 3).
- **`o_power_homing`:** Modifica el puntero principal de armamento a munición guiada.
- **`o_power_overdrive`:** Sobrescribe temporalmente el arma en uso a su variante "Spread", asigna `5` cargas definitivas, y guarda en caché (`pending_weapon`) el ítem previo para una restitución automática al finalizar los disparos.
- **`oL_power_boomerang` & `oL_power_spin`:** Interactúan de forma nativa con el Array de armamento (`weapon_slots`), ejecutando `array_push` y `array_contains` para insertar permanentemente el nuevo equipo a los ciclos de combate del jugador.

---

**Nota Técnica Final:**  
Este documento cubre la integridad funcional, lógica interna y arquitectura del proyecto completo. Toda la manipulación de estados, eventos estocásticos y métodos de física están mapeados en esta guía.
