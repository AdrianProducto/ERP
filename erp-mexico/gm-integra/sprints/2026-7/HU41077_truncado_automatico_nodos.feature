Feature: Truncado automático de nodos al superar el límite permitido
  Como sistema
  Quiero truncar automáticamente los nodos que excedan el límite
  Para mantener la integridad del modelo sin rechazar el archivo completo

  Background:
    Given el sistema tiene un límite de 20 nodos totales y 4 niveles de profundidad

  Scenario: El archivo supera el total de 20 nodos
    Given el usuario carga un archivo cuya estructura tiene más de 20 nodos en total
    When el sistema procesa el archivo
    Then se incluyen únicamente los primeros 20 nodos encontrados
    And el campo nodosOmitidos indica cuántos nodos fueron excluidos
    And se retorna una advertencia describiendo la cantidad omitida y el límite aplicado

  Scenario: El archivo supera los 4 niveles de profundidad
    Given el usuario carga un archivo con elementos anidados a más de 4 niveles
    When el sistema procesa el archivo
    Then los nodos del nivel 5 en adelante se omiten
    And el campo nodosOmitidos es mayor a 0
    And se retorna la advertencia correspondiente

  Scenario: El archivo está dentro del límite permitido
    Given el usuario carga un archivo con menos de 20 nodos y máximo 4 niveles de profundidad
    When el sistema procesa el archivo
    Then nodosOmitidos es 0
    And no se retorna ninguna advertencia
