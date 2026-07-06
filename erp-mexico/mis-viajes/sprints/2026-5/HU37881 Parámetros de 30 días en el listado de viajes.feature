# Característica
@AltaViaje
Feature: Mostrar viajes según el parámetro de 30 días configurado en el ERP

  Como usuario de la App Móvil "Mis Viajes"
  Quiero ver solo los viajes dentro del rango de fechas configurado
  Para no ver viajes muy antiguos que ya no me son útiles

  # Antecedentes
  Background:
    # Dado
    Given que el usuario está autenticado en la App Móvil "Mis Viajes"
    # Y
    And que existen viajes creados hace 10, 25, 35 y 55 días en la base de datos

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Ver viajes según el parámetro de 30 días
    # Dado
    Given que el parámetro "Visualizar viajes de hasta 30 días de elaboración" está <parametro_30_dias>
    # Cuando
    When el usuario abre el listado de viajes en la App Móvil
    # Entonces
    Then el sistema muestra <resultado_esperado>

    # Ejemplos
    Examples:
      | parametro_30_dias    | resultado_esperado                                  |
      | Activo (Checked)     | solo los viajes de los últimos 30 días (10 y 25 días) |
      | Inactivo (Unchecked) | los viajes de los últimos 2 meses (10, 25 y 35 días)  |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  # Esquema del escenario
  Scenario Outline: No mostrar viajes fuera del rango configurado
    # Dado
    Given que el parámetro "Visualizar viajes de hasta 30 días de elaboración" está <parametro_30_dias>
    # Cuando
    When el usuario abre el listado de viajes en la App Móvil
    # Entonces
    Then el sistema NO muestra <viajes_excluidos>

    # Ejemplos
    Examples:
      | parametro_30_dias    | viajes_excluidos                            |
      | Activo (Checked)     | viajes creados hace más de 30 días (35 y 55 días) |
      | Inactivo (Unchecked) | viajes creados hace más de 2 meses (55 días)      |
