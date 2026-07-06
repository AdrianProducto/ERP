# Característica
Feature: Redirección a nueva Pantalla Aeropuerto con inicio de sesión automático
  Como usuario del módulo de Tráfico
  Quiero que al dar clic en el botón Pantalla Aeropuerto se abra la nueva Pantalla Aeropuerto cuando el parámetro esté activo
  Para ingresar automáticamente con mi sesión vigente del ERP mediante un token generado por el servicio auth login

  # Antecedentes
  Background:
    # Dado
    Given que el usuario se encuentra autenticado en el ERP
    # Y
    And que existe el botón "Pantalla Aeropuerto" en el módulo de Tráfico
    # Y
    And que el sistema puede consultar el parámetro "Pantalla de aeropuerto personalizada"
    # Y
    And que el ERP cuenta con integración con el servicio "auth login"

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Redirigir a la nueva Pantalla Aeropuerto e iniciar sesión automáticamente cuando el parámetro está activo
    # Dado
    Given que el parámetro "Pantalla de aeropuerto personalizada" está <estado_parametro>
    # Y
    And que la sesión del usuario en el ERP se encuentra <estado_sesion_erp>
    # Y
    And que el servicio "auth login" responde con <respuesta_auth>
    # Cuando
    When el usuario da clic en el botón "Pantalla Aeropuerto"
    # Entonces
    Then el sistema debe redirigir a <destino_pantalla>
    # Y
    And debe generar y enviar <envio_token>
    # Y
    And la nueva Pantalla Aeropuerto debe autenticar al usuario con <resultado_autenticacion>
    # Y
    And el usuario debe visualizar <resultado_final>

    # Ejemplos
    Examples:
      | estado_parametro | estado_sesion_erp | respuesta_auth | destino_pantalla               | envio_token                     | resultado_autenticacion | resultado_final                                      |
      | activo           | válida            | exitosa        | la nueva Pantalla Aeropuerto   | el token de autenticación       | inicio de sesión exitoso | la nueva Pantalla Aeropuerto con sesión iniciada     |
      | activo           | válida            | exitosa        | la nueva Pantalla Aeropuerto   | el token de forma segura        | acceso automático        | la pantalla principal según sus permisos             |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Validar restricciones de redirección e inicio de sesión automático de Pantalla Aeropuerto
    # Dado
    Given que el parámetro "Pantalla de aeropuerto personalizada" está <estado_parametro>
    # Y
    And que la sesión del usuario en el ERP se encuentra <estado_sesion_erp>
    # Y
    And que el servicio "auth login" responde con <respuesta_auth>
    # Cuando
    When el usuario da clic en el botón "Pantalla Aeropuerto"
    # Entonces
    Then el sistema debe ejecutar <comportamiento_esperado>
    # Y
    And debe mostrar <mensaje_esperado>

    # Ejemplos
    Examples:
      | estado_parametro | estado_sesion_erp | respuesta_auth | comportamiento_esperado                                              | mensaje_esperado                                                          |
      | inactivo         | válida            | no aplica      | el comportamiento actual del botón sin redirigir a la nueva pantalla | sin mensaje de error                                                      |
      | activo           | inválida          | no aplica      | impedir la redirección a la nueva Pantalla Aeropuerto                | un mensaje indicando que la sesión del ERP no es válida                   |
      | activo           | expirada          | no aplica      | impedir la redirección a la nueva Pantalla Aeropuerto                | un mensaje indicando que la sesión del ERP ha expirado                    |
      | activo           | válida            | fallida        | impedir el acceso automático a la nueva Pantalla Aeropuerto          | un mensaje indicando que no fue posible generar el token de autenticación |
      | activo           | válida            | token inválido | impedir la autenticación automática en la nueva Pantalla Aeropuerto  | un mensaje indicando que no fue posible iniciar sesión automáticamente    |
      | activo           | válida            | timeout        | impedir la redirección automática a la nueva Pantalla Aeropuerto     | un mensaje indicando que el servicio de autenticación no respondió        |