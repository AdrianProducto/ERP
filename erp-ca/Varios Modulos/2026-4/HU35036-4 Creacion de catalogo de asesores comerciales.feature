Feature: Creacion de nuevo catalogo "Asesores comerciales"

    Yo como usuario del catalogo de clientes 
    Requiero que se cree un nuevo catalogo para el registro de asesores comerciales
    Para facilitar el registro de asesores comerciales en el catalogo de clientes y poder generar reportes de manera mas clara de ser necesario

Rule: Cambio exclusivo para bases de datos de guatemala

 Scenario: Disponibilidad del catálogo
    Given que el catálogo "Asesores comerciales" existe en el sistema
    When el usuario accede a la sección de catálogos
    Then el sistema muestra el catálogo "Asesores comerciales"
    And cuenta con las opciones Agregar, Modificar y Eliminar

Scenario: Visualizar formulario para agregar asesor comercial
    Given que el usuario accede al catálogo "Asesores comerciales"
    When selecciona la opción Agregar
    Then el sistema muestra los siguientes campos:
      | Campo              | Tipo / Regla                          |
      | Código             | Consecutivo automático no editable    |
      | Asesor comercial   | Alfanumérico de hasta 150 caracteres  |
      | Activo             | Checkbox activo por defecto           |

Scenario: Registrar un asesor comercial
  Given que el usuario se encuentra en el formulario de alta
  When ingresa un "Asesor comercial" válido
  And guarda el registro
  Then el sistema asigna un "Código" consecutivo automático
  And no permite modificar el "Código"
  And guarda el registro correctamente

Scenario: Modificar un asesor comercial
    Given que existe un asesor comercial registrado
    When el usuario edita el registro
    And modifica el campo "Asesor comercial" o el estado "Activo"
    And guarda los cambios
    Then el sistema actualiza la información
    And mantiene el "Código" sin cambios

Scenario: Eliminar un asesor comercial sin relación
    Given que el asesor comercial no está relacionado con registros en el catálogo de clientes
    When el usuario elimina el registro
    Then el sistema elimina el asesor correctamente

  Scenario: Restricción de eliminación por relación con clientes
    Given que el asesor comercial está siendo utilizado en el catálogo de clientes
    When el usuario intenta eliminar el registro
    Then el sistema muestra el siguiente mensaje de error "El registro se encuentra ligado a un cliente, Favor de validar"
    And no permite eliminar el registro

Scenario: Visualización del listado del catálogo
    Given que existen asesores comerciales registrados
    When el usuario consulta el listado
    Then el sistema muestra las columnas:
      | Código | Asesor comercial | Activo |
    And el filtro "Mostrar solo activos"
    And el campo "Activo" muestra "Sí" si está seleccionado el check "Activo" del asesor comercial registrado
    And el campo "Activo" muestra "No" si está desmarcado el check "Activo" del asesor comercial registrado

Scenario: Visualización de clientes relacionados por asesor comercial
    Given que existen asesores comerciales registrados
    And que los asesores comerciales tienen clientes relacionados en el catálogo de clientes
    When el usuario selecciona un asesor comercial registrado
    Then el sistema muestra en un sublistado llamado "Clientes relacionados" los clientes asociados a ese asesor en el catálogo de clientes.

Scenario: Visibilidad en módulos
    Given que el catálogo "Asesores comerciales" existe en el sistema
    When el usuario accede a los módulos de Facturación y Tráfico
    Then el catálogo "Asesores comerciales" está disponible para su uso.    