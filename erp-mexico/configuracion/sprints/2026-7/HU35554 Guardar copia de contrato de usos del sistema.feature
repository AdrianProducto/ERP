Feature: Guardar copia de contrato de usos del sistema
  Como usuario administrador 
  Necesito que se descargue una copia del contrato de usos del sistema una vez aceptado por el cliente
  Para poder consultarlo cuando sea necesario

  Scenario: Guardar copia cuando el cliente acepta el contrato
    Given el usuario ingresa por primera vez al sistema
    When acepta el contrato de usos del sistema
    Then el sistema debe guardar una copia del contrato de usos