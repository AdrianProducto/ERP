# language: es

Feature: HU-37874 Consulta de comentarios de estatus en la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero consultar el comentario asociado al estatus de un trayecto
  Para conocer el contexto operativo del cambio realizado

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario se encuentra en la Pantalla Aeropuerto

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Consulta exitosa del comentario de estatus
    # Dado
    Given que el trayecto tiene comentario de estatus <existencia_comentario>
    # Cuando
    When el usuario selecciona la opción para consultar comentario
    # Entonces
    Then el sistema muestra <resultado_modal>

    Examples:
      | existencia_comentario | resultado_modal                               |
      | registrado            | el modal con el comentario asociado al estatus|
      | registrado            | el último comentario aplicable del movimiento |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Validaciones al consultar comentario de estatus
    # Dado
    Given que el trayecto tiene comentario de estatus <existencia_comentario>
    # Cuando
    When el usuario selecciona la opción para consultar comentario
    # Entonces
    Then el sistema responde con <resultado_esperado>

    Examples:
      | existencia_comentario | resultado_esperado                                                   |
      | no registrado         | informa que no existe comentario registrado para el estatus          |
      | no disponible         | informa que no fue posible recuperar el comentario correspondiente   |