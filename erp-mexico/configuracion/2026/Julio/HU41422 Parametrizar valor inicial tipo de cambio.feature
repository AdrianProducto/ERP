@HU41422 @ParametrizarTipoCambio
Feature: Parametrizar valor inicial del tipo de cambio al iniciar sesión

    Yo como administrador del sistema
    requiero que exista un parámetro configurable por empresa que determine si el campo de
    tipo de cambio al iniciar sesión se precarga con el valor de Banxico o inicia en cero
    Para que cada empresa pueda establecer su procedimiento operativo respecto al tipo de
    cambio del día, garantizando que el valor sea revisado o ingresado de forma deliberada

    Scenario: Visualización del parámetro en Configuración — Parámetros Generales
        Given que el usuario tiene acceso al módulo de Configuración
        When el usuario accede a Configuración — Parámetros Generales, sección "Seguridad y acceso"
        Then el sistema muestra la opción "Iniciar tipo de cambio en cero al agregar" con un checkbox
        And el checkbox aparece desmarcado por defecto

    Scenario: Activar el parámetro y persistir el cambio por empresa
        Given que el usuario tiene acceso al módulo de Configuración
        And el parámetro "Iniciar tipo de cambio en cero al agregar" está desmarcado en la empresa activa
        When el usuario marca el checkbox "Iniciar tipo de cambio en cero al agregar" y guarda la configuración
        Then el sistema guarda el cambio para la empresa activa
        And el parámetro permanece marcado al volver a abrir la pantalla de Parámetros Generales

    Scenario: Popup de tipo de cambio con parámetro desmarcado — valor Banxico precargado
        Given que el parámetro "Iniciar tipo de cambio en cero al agregar" está desmarcado en la empresa activa
        And el tipo de cambio del día aún no ha sido capturado en la empresa activa
        When el usuario inicia sesión y el sistema presenta el popup de tipo de cambio
        Then el campo "Tipo de cambio" muestra precargado el valor del día proporcionado por Banxico (por ejemplo "17.5432")
        And el usuario puede confirmar ese valor haciendo clic en "Aceptar" o modificarlo antes de aceptar

    Scenario: Popup de tipo de cambio con parámetro marcado — campo en cero y referencia Banxico
        Given que el parámetro "Iniciar tipo de cambio en cero al agregar" está marcado en la empresa activa
        And el tipo de cambio del día aún no ha sido capturado en la empresa activa
        When el usuario inicia sesión y el sistema presenta el popup de tipo de cambio
        Then el campo "Tipo de cambio" se muestra con valor "0"
        And debajo del campo se muestra el valor de Banxico del día como referencia (por ejemplo "Banxico hoy: 17.5432")
        And el botón "Aceptar" está habilitado para que el usuario ingrese el tipo de cambio manualmente

    Scenario: Validación — no es posible confirmar con tipo de cambio en cero
        Given que el parámetro "Iniciar tipo de cambio en cero al agregar" está marcado en la empresa activa
        And el popup de tipo de cambio está abierto con el campo en valor "0"
        When el usuario hace clic en "Aceptar" sin ingresar un valor mayor a cero
        Then el sistema muestra el mensaje de validación existente que indica que el tipo de cambio no puede ser cero
        And el popup permanece abierto hasta que el usuario ingrese un valor mayor a cero

    Scenario: Parámetro marcado en Empresa A — popup inicia en cero
        Given que el parámetro "Iniciar tipo de cambio en cero al agregar" está marcado en la empresa "Empresa A"
        And el tipo de cambio del día aún no ha sido capturado en "Empresa A"
        When el usuario inicia sesión en "Empresa A" y el sistema presenta el popup de tipo de cambio
        Then el campo "Tipo de cambio" se muestra con valor "0"
        And debajo del campo se muestra el valor de Banxico del día como referencia

    Scenario: Parámetro desmarcado en Empresa B — popup muestra valor Banxico
        Given que el parámetro "Iniciar tipo de cambio en cero al agregar" está desmarcado en la empresa "Empresa B"
        And el tipo de cambio del día aún no ha sido capturado en "Empresa B"
        When el usuario inicia sesión en "Empresa B" y el sistema presenta el popup de tipo de cambio
        Then el campo "Tipo de cambio" muestra precargado el valor del día proporcionado por Banxico
