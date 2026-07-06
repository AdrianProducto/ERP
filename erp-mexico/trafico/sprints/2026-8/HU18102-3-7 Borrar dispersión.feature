Feature: Borrar dispersión
  Como usuario de tráfico
  Necesito poder eliminar una disperción existente
  Para no conservar registros creados por error o que no seran utilizados

  Scenario: Mensaje de confirmación para borrar dispersión
    Given el usuario se encuentra en el listado de dispersión
    And existen dispersiones generadas
    When el usuario solicita eliminar la dispersión
    Then el sistema debe solicitar la confirmación del borrado por medio del mensaje:
    """
      ¿Está seguro que desea borrar la  dispersión <nombre_dispersion>?
    """
    And el mensaje contiene las opciones:
      | Si |
      | No |

  Scenario: Confirmar acción
    Given el sistema presenta el mensaje de confirmación
    When el usuario confirma la acción de borrar la dispersión
    Then el sistema elimina la relación de los anticipos relacionados con la dispersión correspondiente 
    And elimina el registro de la dispersión

  Scenario: No confirma acción
    Given el sistema presenta el mensaje de confirmación
    When el usuario no confirma la acción de borrar disperción
    Then el sistema no realiza ningun cambio