Feature: Mostrar lista de dispersiones
  Como usuario de tráfico 
  Necesito poder consultar las dispersiones de liquidaciones generadas
  Para poder gestionarlas

  Scenario: Actualización en derechos de usuario
    Given el usuario se encuentra asignando derechos a un usuario del sistema
    And accede al modulo de Tráfico
    When selecciona el proceso Liquidaciones
    Then debe mostrarse el proceso "Disp. Avanzada"

  Scenario: Actualización en bitácora de procesos
    Given el usuario se encuentra consultando la bitacora de procesos
    And accede al proceso de Tráfico
    When selecciona el proceso Liquidaciones
    Then debe mostrarse el proceso "Disp. Avanzada"

  Scenario: Mostrar nuevo proceso de dispersión avanzada para liquidaciones
    Given el usuario se encuentra logueado en el sistema
    When solicite ingresar al listado de liquidaciones del modulo de tráfico
    And cuente con los permisos sobre el proceso de dispersión avanzada para liquidaciones
    Then el sistema presenta el boton "Disp. Avanzada" como parte de las opciones del listado

  Scenario: Ocultar nuevo proceso de dispersión avanzada para liquidaciones
    Given el usuario se encuentra logueado en el sistema
    When solicite ingresar al listado de liquidaciones del modulo de tráfico
    And no cuenta con los permisos sobre el proceso de dispersión avanzada para liquidaciones
    Then el sistema no debe mostrar el boton "Disp. Avanzada" como parte de las opciones del listado

  Scenario: Mostrar lista de dispersiones 
    Given el usuario se encuentra en el listado de liquidaciones
    When da clic en el boton "Disp. Avanzada"
    Then el sistema presenta un listado con las dispersiones existentes
    And por cada registro muestra la siguiente información:
      | Descripción     | 
      # Nombre otorgado a la dispersión. Dato capturado durante el registro de la dispersión 
      | Fecha           | 
      #Fecha en la que se registra la dispersión. Fecha seleccionada durante el registro de la dispersión. No confundir con Fecha de aplicación 
      | Banco           | 
      #Banco asociado a la cuenta seleccionada al registrar la dispersión 
      | Cuenta bancaria | 
      #Cuenta bancaria desde la cual se realizan los pagos. Seleccionada durante la creación de la dispersión 
    And presenta las siguientes opciones:
      | Generar nueva dispersión   |
      | Pagar dispersión           |
      | Consultar dispersión       |
      | Modificar dispersión       |
      | Borrar dispersión          |





