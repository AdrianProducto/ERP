@AltaViaje

# Característica
Feature: Setup base del sistema (Login con usuario/contraseña y roles Operaciones/Admin)

  Como Operaciones
  Quiero autenticarme en el sistema mediante usuario y contraseña
  Para acceder a las funcionalidades del MVP de Recorridos/Viajes y Prefacturación

  # Antecedentes
  Background:
    # Dado
    Given que existen usuarios cargados manualmente en base de datos con los campos usuario, correo, nombre, contraseña, rol y estatus activo
    # Y
    And que los roles disponibles en el MVP son "Operaciones" y "Admin"
    # Y
    And que en el MVP ambos roles tienen los mismos permisos funcionales
    # Y
    And que en el MVP no aplica recuperación de contraseña, expiración de sesión ni bloqueo por intentos fallidos
    # Y
    And que no se requiere bootstrap de datos iniciales al iniciar el sistema

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Iniciar sesión exitosamente con credenciales válidas y usuario activo
    # Dado
    Given que el usuario existe con <usuario> y su estatus es <estatus_usuario>
    # Y
    And que el usuario proporciona la contraseña <contrasena>
    # Cuando
    When el usuario intenta iniciar sesión
    # Entonces
    Then el sistema autentica al usuario y permite el acceso
    # Y
    And el sistema asigna la sesión al rol <rol_usuario>
    # Y
    And el sistema muestra el módulo inicial del MVP <pantalla_inicial>

    # Ejemplos
    Examples:
      | usuario      | contrasena   | estatus_usuario | rol_usuario  | pantalla_inicial                 |
      | op_user_01   | Valida123    | Activo         | Operaciones  | "Listado de Recorridos/Viajes"   |
      | admin_user_1 | Valida123    | Activo         | Admin        | "Listado de Recorridos/Viajes"   |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear inicio de sesión por credenciales inválidas o usuario inactivo
    # Dado
    Given que la condición inválida de autenticación es <condicion_invalida>
    # Y
    And que el usuario intenta iniciar sesión con <usuario> y contraseña <contrasena>
    # Cuando
    When el usuario intenta iniciar sesión
    # Entonces
    Then el sistema bloquea el acceso y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | condicion_invalida                 | usuario       | contrasena  | error_esperado                                                |
      | "Usuario no existe"                | no_existe     | Valida123   | "Credenciales inválidas: usuario o contraseña incorrectos."    |
      | "Contraseña incorrecta"            | op_user_01    | Incorrecta  | "Credenciales inválidas: usuario o contraseña incorrectos."    |
      | "Usuario inactivo"                 | op_user_02    | Valida123   | "Acceso denegado: el usuario se encuentra inactivo."           |
      | "Usuario vacío"                    | VACIO         | Valida123   | "El usuario es obligatorio."                                   |
      | "Contraseña vacía"                 | op_user_01    | VACIO       | "La contraseña es obligatoria."                                |

  # Escenario adicional requerido para validar estructuras complejas (estructura de usuario) usando Doc Strings
  Scenario: Validar estructura mínima de un usuario cargado en base de datos para autenticación
    # Dado
    Given que la estructura mínima esperada de un usuario en base de datos es la siguiente
      """
      {
        "usuario": "op_user_01",
        "correo": "operaciones@empresa.com",
        "nombre": "Usuario Operaciones",
        "contrasena_hash": "hash",
        "rol": "Operaciones|Admin",
        "activo": true
      }
      """
    # Cuando
    When el sistema valida la autenticación con usuario y contraseña
    # Entonces
    Then el sistema debe requerir que el usuario exista, esté activo y tenga rol permitido en el MVP
