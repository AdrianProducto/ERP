Feature: Validación de informacion bancaria en dispersion avanzada
  Como usuario de cuentas por pagar
  Quiero que se valide la información bancaria de los proveedores
  Para evitar generar archivos de dispersión con informacion incompleta

  Scenario Outline: Validación de datos bancarios
      Given que el usuario solicita generar la dispersión avanzada
      And el proveedor tiene un banco <banco_proveedor>
      And la cuenta de dispersión tiene un banco <banco_dispersion>
      And el proveedor tiene una cuenta bancaria <cuenta_bancaria> 
      And tiene una CLABE <clabe>
      When el sistema valida la información bancaria
      Then el resultado debe ser <resultado>

      Examples:
        | banco_proveedor | banco_dispersion | cuenta_bancaria | clabe              | resultado |
        | sin banco       | BANORTE          | sin datos       | sin datos          | error     |
        | BANORTE         | BANORTE          | 0123456789      | sin datos          | válido    |
        | BANORTE         | BANORTE          | 0123456789      | 012345678901234567 | válido    |
        | BANORTE         | BANORTE          | sin cuenta      | 012345678901234567 | error     |
        | BANORTE         | BANORTE          | sin cuenta      | sin datos          | error     |
        | BBVA            | BANORTE          | sin datos       | 765432109876543210 | válido    |
        | BBVA            | BANORTE          | 9876543210      | 765432109876543210 | válido    |
        | BBVA            | BANORTE          | sin datos       | sin datos          | error     |
        | BBVA            | BANORTE          | 9876543210      | sin datos          | error     |
  
  Scenario: Mostrar mensaje de datos bancarios no validos
      Given que existen proveedores con información bancaria incompleta
      When el usuario intenta generar la dispersión avanzada
      Then se muestra el mensaje: "Los siguientes proveedores no cuentan con su información bancaria completa."
      And se muestra el listado de proveedores con error
      And no se genera el archivo de dispersión




  
