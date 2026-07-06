Feature: Generación de reportes en segundo plano con filtros repetidos

  Como usuario de Inventarios
  Quiero poder generar nuevamente reportes enviados a segundo plano aun cuando existan reportes previos con los mismos filtros
  Para obtener información actualizada.

  Background:
    Given el usuario se encuentra en la pantalla de generación de reportes
    And existe el apartado "Reportes Generados"

  Scenario: Generar un reporte por primera vez
    Given el usuario selecciona filtros válidos para un reporte
    And no existe un reporte en proceso con los mismos filtros
    When el usuario solicita generar el reporte en segundo plano
    Then el sistema debe iniciar la generación del reporte
    And el sistema debe notificar al usuario cuando el reporte finalice (haya sido creado)
    And el reporte debe almacenarse en "Reportes Generados"

  Scenario: Permitir generar nuevamente un reporte con los mismos filtros
    Given existe un reporte previamente generado con los mismos filtros
    And no existe un reporte en proceso con los mismos filtros
    When el usuario solicita generar nuevamente el reporte
    Then el sistema debe mostrar el mensaje:
      """
      Ya existe un reporte creado con los mismos filtros, ¿desea actualizarlo?
      """
    And el sistema debe mostrar las opciones:
      | Opcion |
      | Si     |
      | No     |

  Scenario: Confirmar generación nuevamente con mismos filtros
    Given existe un reporte previamente generado con los mismos filtros
    And no existe un reporte en proceso con los mismos filtros
    When el usuario selecciona la opción "Si"
    Then el sistema debe generar nuevamente el reporte
    And el reporte debe considerar la información actualizada
    And el reporte debe almacenarse en "Reportes Generados"

  Scenario: Cancelar generación nuevamente con mismos filtros
    Given existe un reporte previamente generado con los mismos filtros
    And no existe un reporte en proceso con los mismos filtros
    When el usuario selecciona la opción "No"
    Then el sistema no debe generar un nuevo reporte
    And el sistema debe regresar a la ventana anterior

  Scenario: Impedir generar un reporte mientras existe otro en proceso
    Given existe un reporte en proceso de generación con los mismos filtros
    When el usuario intenta generar nuevamente el reporte
    Then el sistema no debe permitir iniciar una nueva generación
    And el sistema debe mostrar el mensaje:
      """
      Existe un reporte en proceso de generación. Por favor, espere a que finalice para poder generar uno nuevo.
      """

  Scenario: Permitir múltiples generaciones del mismo reporte
    Given existe un reporte previamente generado con los mismos filtros
    And el reporte anterior ya finalizó correctamente
    And no existe un proceso activo de generación
    When el usuario solicita generar nuevamente el reporte
    Then el sistema debe permitir la nueva generación
    And el nuevo reporte debe generarse con información actualizada