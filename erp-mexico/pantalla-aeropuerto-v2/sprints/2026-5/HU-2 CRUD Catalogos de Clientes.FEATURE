# Característica
Feature: CRUD de Clientes/Empresas con RFC único, estatus Activo/Inactivo y restricciones por registros relacionados

  Como Operaciones
  Quiero administrar el catálogo de Clientes/Empresas (crear, editar, consultar, eliminar o desactivar)
  Para mantener actualizada la información de los clientes y controlar su uso en la programación de viajes y generación de prefacturas

  # Antecedentes
  Background:
    # Dado
    Given que el usuario autenticado tiene un rol permitido en el MVP <rol_usuario> (Operaciones/Admin)
    # Y
    And que el catálogo de Clientes maneja los campos: nombre, RFC, razón social, contacto, teléfono, correo, dirección y estatus Activo/Inactivo
    # Y
    And que el RFC debe ser único cuando se capture
    # Y
    And que un cliente inactivo puede conservar viajes/prefacturas históricas
    # Y
    And que no se permite programar viajes ni generar prefacturas para clientes inactivos
    # Y
    And que solo se permite eliminar físicamente un cliente si no tiene registros relacionados

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Crear, editar, consultar, eliminar o desactivar un cliente cumpliendo reglas del catálogo
    # Dado
    Given que la operación solicitada es <operacion>
    # Y
    And que el cliente tiene nombre <nombre>
    # Y
    And que el RFC capturado es <rfc>
    # Y
    And que la razón social es <razon_social>
    # Y
    And que el contacto es <contacto>
    # Y
    And que el teléfono es <telefono>
    # Y
    And que el correo es <correo>
    # Y
    And que la dirección es <direccion>
    # Y
    And que el estatus inicial del cliente es <estatus_inicial>
    # Y
    And que el cliente tiene registros relacionados <tiene_registros_relacionados>
    # Cuando
    When el usuario intenta ejecutar la operación en el catálogo de clientes
    # Entonces
    Then el sistema completa la operación y obtiene el resultado <resultado_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | operacion    | nombre      | rfc        | razon_social     | contacto     | telefono    | correo                 | direccion          | estatus_inicial | tiene_registros_relacionados | resultado_esperado                                                |
      | Operaciones | Crear        | Cliente A   | RFC123456  | "RS Cliente A"   | "Juan Pérez" | "686000000" | "a@cliente.com"        | "Dirección 1"      | Activo          | No                         | "Cliente creado exitosamente en estatus Activo."                  |
      | Admin       | Editar       | Cliente A   | RFC123456  | "RS Cliente A 2" | "Ana López"  | "686111111" | "contacto@cliente.com" | "Dirección 2"      | Activo          | Sí                         | "Cliente actualizado exitosamente."                               |
      | Operaciones | Consultar    | N/A         | N/A        | N/A              | N/A          | N/A         | N/A                    | N/A                | N/A             | N/A                        | "Se muestra el listado/detalle de clientes según filtros."        |
      | Admin       | Desactivar   | Cliente B   | RFC999999  | "RS Cliente B"   | "Mario Díaz" | "686222222" | "b@cliente.com"        | "Dirección 3"      | Activo          | Sí                         | "Cliente desactivado: estatus cambia a Inactivo."                 |
      | Admin       | Eliminar     | Cliente C   | RFC777777  | "RS Cliente C"   | "Luisa Rey"  | "686333333" | "c@cliente.com"        | "Dirección 4"      | Activo          | No                         | "Cliente eliminado físicamente (sin registros relacionados)."     |

  # Esquema del escenario
  Scenario Outline: Consultar clientes con búsqueda por nombre/RFC, filtro de estatus y paginación
    # Dado
    Given que el usuario se encuentra en el listado de clientes
    # Y
    And que el criterio de búsqueda por nombre es <busqueda_nombre>
    # Y
    And que el criterio de búsqueda por RFC es <busqueda_rfc>
    # Y
    And que el filtro de estatus está configurado como <filtro_estatus>
    # Y
    And que el usuario navega a la página <pagina>
    # Cuando
    When el usuario aplica los filtros del listado de clientes
    # Entonces
    Then el sistema muestra <resultado_esperado> con paginación activa en la página <pagina>

    # Ejemplos
    Examples:
      | rol_usuario | busqueda_nombre | busqueda_rfc | filtro_estatus      | pagina | resultado_esperado                                                   |
      | Operaciones | "Cliente"       | VACIO        | Activo              | 1      | "Lista de clientes activos cuyo nombre coincide con la búsqueda."     |
      | Admin       | VACIO           | "RFC123"     | Activo,Inactivo     | 2      | "Lista de clientes activos e inactivos cuyo RFC coincide con búsqueda."|

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear operaciones por campos obligatorios, RFC duplicado o eliminación con registros relacionados
    # Dado
    Given que la condición inválida es <condicion_invalida>
    # Y
    And que la operación solicitada es <operacion>
    # Y
    And que el nombre del cliente es <nombre>
    # Y
    And que el RFC capturado es <rfc>
    # Y
    And que el cliente tiene registros relacionados <tiene_registros_relacionados>
    # Cuando
    When el usuario intenta ejecutar la operación en el catálogo de clientes
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | condicion_invalida                               | operacion  | nombre     | rfc        | tiene_registros_relacionados | error_esperado                                                                 |
      | Operaciones | "Nombre vacío"                                   | Crear      | VACIO      | RFC123456  | No                         | "El nombre del cliente es obligatorio."                                        |
      | Operaciones | "RFC duplicado"                                  | Crear      | Cliente X  | RFC123456  | No                         | "El RFC capturado ya existe: debe ser único."                                  |
      | Admin       | "Eliminar cliente con viajes/prefacturas"        | Eliminar   | Cliente A  | RFC123456  | Sí                         | "No se puede eliminar: el cliente tiene registros relacionados. Use Desactivar."|
      | Operaciones | "Cliente inactivo (uso no permitido)"            | CrearViaje | Cliente B  | RFC999999  | Sí                         | "No se puede programar viajes: el cliente se encuentra Inactivo."              |
      | Operaciones | "Cliente inactivo (prefactura no permitida)"     | Prefactura | Cliente B  | RFC999999  | Sí                         | "No se puede generar prefactura: el cliente se encuentra Inactivo."            |

  # Esquema del escenario
  Scenario Outline: Bloquear gestión del catálogo por permisos insuficientes
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Cuando
    When el usuario intenta acceder o modificar el catálogo de clientes
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario  | error_esperado                                                    |
      | SinPermisos  | "Acceso denegado: no cuenta con permisos para administrar clientes."|

  # Escenario adicional requerido para validar estructuras complejas (estructura mínima de Cliente) usando Doc Strings
  Scenario: Validar estructura mínima de Cliente/Empresa en el MVP
    # Dado
    Given que la estructura mínima esperada de un cliente es la siguiente
      """
      {
        "nombre": "Cliente A",
        "rfc": "RFC123456",
        "razon_social": "RS Cliente A",
        "contacto": "Juan Pérez",
        "telefono": "686000000",
        "correo": "a@cliente.com",
        "direccion": "Dirección 1",
        "estatus": "Activo|Inactivo"
      }
      """
    # Cuando
    When el sistema valida la creación o actualización de un cliente
    # Entonces
    Then el sistema debe requerir nombre obligatorio y RFC único cuando el RFC sea capturado