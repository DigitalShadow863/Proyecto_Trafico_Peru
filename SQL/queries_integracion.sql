SELECT 
    t.anio, 
    r.region, 
    v.tipo_vehiculo, 
    vi.tipo_via, 
    c.condicion_climatica, 
    f.fuente, 
    h.flujo_vehicular, 
    h.pasajeros_transportados, 
    h.accidentes, 
    h.velocidad_promedio
FROM HECHOS_TRAFICO h
JOIN DIM_TIEMPO t ON h.id_tiempo = t.id_tiempo
JOIN DIM_REGION r ON h.id_region = r.id_region
JOIN DIM_VEHICULO v ON h.id_vehiculo = v.id_vehiculo
JOIN DIM_VIA vi ON h.id_via = vi.id_via
JOIN DIM_CLIMA c ON h.id_clima = c.id_clima
JOIN DIM_FUENTE f ON h.id_fuente = f.id_fuente;
-- Consulta 1: Tráfico por año
SELECT 
    t.anio, 
    SUM(h.flujo_vehicular) AS total_trafico
FROM HECHOS_TRAFICO h
JOIN DIM_TIEMPO t ON h.id_tiempo = t.id_tiempo
GROUP BY t.anio
ORDER BY t.anio;

CREATE DATABASE IF NOT EXISTS analisis_trafico_peru;
USE analisis_trafico_peru;


SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS HECHOS_TRAFICO, DIM_TIEMPO, DIM_VEHICULO, DIM_CLIMA, DIM_REGION, DIM_VIA, DIM_FUENTE;
SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE DIM_TIEMPO (
    id_tiempo INT PRIMARY KEY,
    fecha DATE,
    dia INT,
    nombre_dia VARCHAR(10),
    semana INT,
    mes INT,
    nombre_mes VARCHAR(15),
    trimestre INT,
    anio INT,
    es_fin_de_semana BOOLEAN,
    es_feriado BOOLEAN
);

CREATE TABLE DIM_VEHICULO (
    id_vehiculo INT PRIMARY KEY,
    tipo_vehiculo VARCHAR(50),
    categoria VARCHAR(30),
    combustible VARCHAR(20),
    anio_fabricacion INT,
    es_transporte_publico BOOLEAN
);

CREATE TABLE DIM_CLIMA (
    id_clima INT PRIMARY KEY,
    condicion_climatica VARCHAR(30),
    temperatura_promedio DECIMAL(5,2),
    precipitacion_mm DECIMAL(10,2),
    humedad_relativa DECIMAL(5,2),
    visibilidad_km DECIMAL(5,2)
);

CREATE TABLE DIM_REGION (
    id_region INT PRIMARY KEY,
    region VARCHAR(50),
    provincia VARCHAR(50),
    distrito VARCHAR(50),
    latitud DECIMAL(10,6),
    longitud DECIMAL(10,6),
    zona VARCHAR(20)
);

CREATE TABLE DIM_VIA (
    id_via INT PRIMARY KEY,
    nombre_via VARCHAR(100),
    tipo_via VARCHAR(30),
    jerarquia_via VARCHAR(20),
    longitud_km DECIMAL(10,2),
    num_carriles INT,
    estado_via VARCHAR(20)
);

CREATE TABLE DIM_FUENTE (
    id_fuente INT PRIMARY KEY,
    fuente VARCHAR(100),
    institucion VARCHAR(100),
    tipo_dato VARCHAR(50),
    metodo_recoleccion VARCHAR(100),
    calidad_dato VARCHAR(20),
    fecha_actualizacion DATE
);


CREATE TABLE HECHOS_TRAFICO (
    id_hecho INT PRIMARY KEY,
    id_tiempo INT,
    id_region INT,
    id_vehiculo INT,
    id_via INT,
    id_clima INT,
    id_fuente INT,
    flujo_vehicular INT,
    carga_transportada DECIMAL(18,2),
    pasajeros_transportados INT,
    accidentes INT,
    tiempo_promedio_viaje DECIMAL(10,2),
    velocidad_promedio DECIMAL(10,2),
    FOREIGN KEY (id_tiempo) REFERENCES DIM_TIEMPO(id_tiempo),
    FOREIGN KEY (id_region) REFERENCES DIM_REGION(id_region),
    FOREIGN KEY (id_vehiculo) REFERENCES DIM_VEHICULO(id_vehiculo),
    FOREIGN KEY (id_via) REFERENCES DIM_VIA(id_via),
    FOREIGN KEY (id_clima) REFERENCES DIM_CLIMA(id_clima),
    FOREIGN KEY (id_fuente) REFERENCES DIM_FUENTE(id_fuente)
);


INSERT INTO DIM_TIEMPO (id_tiempo, fecha, anio) VALUES (1, '2026-05-10', 2026);
INSERT INTO DIM_REGION (id_region, region) VALUES (1, 'Lima');
INSERT INTO DIM_VEHICULO (id_vehiculo, tipo_vehiculo) VALUES (1, 'Auto');
INSERT INTO DIM_VIA (id_via, tipo_via) VALUES (1, 'Autopista');
INSERT INTO DIM_CLIMA (id_clima, condicion_climatica) VALUES (1, 'Soleado');
INSERT INTO DIM_FUENTE (id_fuente, fuente) VALUES (1, 'Waze');

INSERT INTO HECHOS_TRAFICO (id_hecho, id_tiempo, id_region, id_vehiculo, id_via, id_clima, id_fuente, flujo_vehicular) 
VALUES (1, 1, 1, 1, 1, 1, 1, 500);


SELECT r.region, SUM(h.flujo_vehicular) AS total_trafico
FROM HECHOS_TRAFICO h
JOIN DIM_REGION r ON h.id_region = r.id_region
GROUP BY r.region;