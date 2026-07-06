Feature: Asignar automaticamente valores FALSE-TRUE al exportar QuickBooks
  Como usuario
  Necesito que ciertas columnas se llenen automáticamente con FALSE o TRUE al exportar
  Para evitar errores de importación en QuickBooks sin tener que configurarlo cada vez

  Scenario: Columnas FALSE en apartado Invoice
    Given el usuario genera el archivo desde la utileria QuickBooks
    When el sistema esta exportando la informacion del apartado Invoice
    Then el sistema asigna el valor FALSE a la columna AM - Product/Service Taxable

  Scenario: Columnas FALSE en apartado Bills
    Given el usuario genera el archivo desde la utileria QuickBooks
    When el sistema esta exportando la informacion del apartado Bills
    Then el sistema asigna el valor FALSE a las siguientes columnas:
      | columna | nombre columna                  |
      | Q       | Expense Billable Status         | 
      | U       | Expense Taxable                 |
      | AA      | Product/Service Billable Status |
      | AB      | Product/Service Taxable         |

  Scenario: Columnas FALSE en apartado Vendor Credits
    Given el usuario genera el archivo desde la utileria QuickBooks
    When el sistema esta exportando la informacion del apartado Vendor Credits
    Then el sistema asigna el valor FALSE a las siguientes columnas:
      | columna | nombre columna          |
      | P       | Expense Billable Status | 
      | T       | Expense Taxable         |
      | AA      | Line Item Taxable       |

  Scenario: Columnas FALSE en apartado Credit Memos
    Given el usuario genera el archivo desde la utileria QuickBooks
    When el sistema esta exportando la informacion del apartado Credit Memos
    Then el sistema asigna el valor FALSE a las siguientes columnas:
      | columna | nombre columna           |
      | X       | Product/Service Taxable  | 
      | AC      | Apply Tax After Discount |
      | AI      | Print Status             |
      | AJ      | Email Status             |
    
  Scenario: Columnas U y V en blanco si Expense Billable Status es FALSE (Vendor Credits) 
    Given la columna P de Vendor Credits tiene valor FALSE 
    Then las columnas U y V de ese registro quedan en blanco 
    
  Scenario: Columna TRUE en Bill Payments 
    Given el usuario genera el archivo desde la utileria QuickBooks
    When el sistema esta exportando la informacion del apartado Bill Payments
    Then el sistema asigna el valor TRUE a la columna J - Print Status