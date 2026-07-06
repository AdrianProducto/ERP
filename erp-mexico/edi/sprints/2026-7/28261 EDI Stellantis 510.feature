Feature: Integración EDI 510
Como usuario de EDI
Quiero realizar la integración del EDI 510
Para automatizar el envío de archivos EDI al concluir un viaje
Nombre del EDI: Stellantis 510 
 
Scenario: El EDI 510 se ejecuta según la configuración del catálogo Remitente y Destinatario
 
Given que el remitente tiene el check "Es Patio" inactivo
And el destinatario tiene el check "Es Patio" inactivo
And el viaje se marca como "Terminado"
When se ejecuta el proceso de envío EDI al concluir el viaje
Then se genera y envía el archivo EDI 510

Given que el remitente tiene el campo "Es Patio" inactivo
And que el destinatario tiene el campo "Es Patio" activo
And el viaje se marca como "Terminado"
When se ejecuta el proceso de envío EDI al concluir el viaje
Then se genera y envía el archivo EDI 510
 
Given que el remitente tiene el campo "Es Patio" activo
And que el destinatario tiene el campo "Es Patio" inactivo
And el viaje se marca como "Terminado"
When se ejecuta el proceso de envío EDI al concluir el viaje
Then se genera y envía el archivo EDI 510
 
Scenario: No generar EDI 510 cuando remitente y destinatario son ambos Patio
Given que el remitente tiene el campo "Es Patio" activo
And que el destinatario tiene el campo "Es Patio" activo
And el viaje se marca como "Terminado"
When se ejecuta el proceso de envío EDI al concluir el viaje
Then no se genera ni envía el archivo EDI 510

Scenario: No generar EDI 510 si el viaje no ha sido marcado como Terminado
Given que el remitente y destinatario cumplen una combinación válida para EDI 510
And el viaje se encuentra en un estado distinto a "Terminado"
When se consulta el estado del proceso EDI
Then no se genera ni envía el archivo EDI 510
And el sistema permanece a la espera del cambio de estado del viaje