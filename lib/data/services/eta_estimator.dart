/// Estimación simple de ETA por distancia de tramos para vistas que no
/// tienen un escenario de ETA por-parada (sección 9) disponible — p. ej.
/// mirar varias paradas por delante de un bus en S3/S5. No es una
/// predicción real; es una progresión fija usada solo para que la UI
/// muestre algo creciente y razonable.
int sequentialEtaMinutes(int indexFromNow) => 2 + indexFromNow * 4;
