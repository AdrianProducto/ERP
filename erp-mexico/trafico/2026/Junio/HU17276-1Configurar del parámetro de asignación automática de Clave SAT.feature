Feature: Configuración del parámetro de asignación automática de Clave SAT
  Como administrador del sistema de Tráfico
  Quiero configurar un parámetro general para la asignación automática de Clave SAT
  Para minimizar errores de captura manual en la generación del complemento Carta Porte

  Background: 
    Given el usuario ha iniciado sesión en el sistema con permisos de administración
    And ha accedido al módulo de Tráfico
    And ha ingresado al catálogo de Parámetros Generales

  Scenario: Visualizar el nuevo parámetro en el catálogo
    Given se consulta el catálogo de Parámetros Generales
    When ingresa a la sección de viajes
    Then deboe visualizarse el parámetro "Asignación automática de Clave SAT a unidades"

  Scenario: Mostrar mensaje informativo al posicionar el cursor sobre el parámetro
    Given el usuario visualizo el parámetro "Asignación automática de Clave SAT a unidades"
    When posiciona el cursor sobre dicho parámetro
    Then el sistema debe mostrar el mensaje informativo:
      """
        Activa la asignación automática de la clave correspondiente a la configuración vehicular utilizada 
        para el traslado de bienes y/o mercancías durante el registro de una Carta Porte.
      """

  Scenario: Mostrar mensaje de advertencia al activar el parámetro
    Given que el parámetro "Asignación automática de Clave SAT a unidades" se encuentra deshabilitado
    When el usuario activa dicho parámetro
    Then el sistema debe mostrar el siguiente mensaje de advertencia:
      "Para el correcto funcionamiento de esta funcionalidad, es necesario que las unidades registradas 
      cuenten con la configuración adecuada de ejes y llantas. En caso contrario, se asignará la clave SAT 
      configurada en el tipo de unidad."

  Scenario: Guardar la activación del parámetro
    Given que se muestra el mensaje de advertencia al activar el parámetro
    When el usuario confirma la activación
    Then el parámetro "Asignación automática de Clave SAT a unidades" debe quedar habilitado
    And dicha configuración debe considerarse para los siguientes registros de Carta Porte

  Scenario: Deshabilitar el parámetro
    Given que el parámetro "Asignación automática de Clave SAT a unidades" se encuentra habilitado
    When el usuario deshabilita dicho parámetro
    Then el sistema debe conservar el comportamiento actual
    And el atributo ConfigVehicular deberá tomar como valor la Clave SAT configurada en el Tipo de Unidad
