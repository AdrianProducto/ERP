Feature: Programación de generación de pólizas a sistema SAP

  Como usuario de Contabilidad
  Quiero poder configurar el día y la hora de ejecución del proceso de generación de pólizas a sistema SAP
  Para que el proceso se ejecute automáticamente en el horario requerido

  Background:
    Given que el proceso de generación de pólizas actualmente se ejecuta de forma mensual automática
    And no permite configuración de día ni hora por parte del usuario

  Scenario: Visualización de configuración al activar la opción
    Given que el usuario se encuentra en la configuración del proceso
    When activa el check "Generar pólizas a sistema SAP"
    Then se deben mostrar los siguientes campos:
      | Hora                 |
      | Días de la semana    |
    And ya no se podrá configurar la ejecución mensual automática
    And es requerido configurar los días y hora para poder guardar

  Scenario: Selección de días de ejecución
    Given que el usuario activó la opción de generación de pólizas
    When selecciona uno o más días de la semana por medio de checkbox
    Then el sistema debe guardar los días seleccionados para la ejecución del proceso

  Scenario: Configuración de hora de ejecución
    Given que el usuario activó la opción de generación de pólizas
    When define una hora de ejecución
    Then la hora deberá aplicar para todos los días seleccionados

  Scenario: Ejecución automática del proceso
    Given que el usuario configuró los días y la hora de ejecución
    When se cumpla el día y la hora configurados
    Then el sistema debe ejecutar automáticamente el proceso de generación de pólizas a sistema SAP