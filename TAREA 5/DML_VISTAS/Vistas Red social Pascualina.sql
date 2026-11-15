
-- ============================================================
-- PROYECTO: Red social Pascualina
-- Consulta DML de la tarea N°5
-- SGBD: postgreSQL
-- ============================================================

   /* OBJETIVO:
   Se crean vistas con el fin de facilitar el analisis de la informacion
   relacionada con los estudiantes, sus intereses, publicaciones,
   reacciones y la participacion en grupos /*

-- ============================================================
-- Vista N°1:
-- Estudiantes e intereses
-- ============================================================

CREATE OR REPLACE VIEW vw_estudiantes_intereses AS
SELECT
    e.id_estudiante AS codigo_estudiante,
    e.nombre || ' ' || e.apellido AS nombre_completo,
    e.carrera AS carrera,
    i.nombre AS nombre_interes,
    i.tipo AS tipo_interes
FROM estudiante e
INNER JOIN estudiante_interes ei
    ON e.id_estudiante = ei.id_estudiante
INNER JOIN interes i
    ON ei.id_interes = i.id_interes;


-- ============================================================
-- Vista N°2:
-- Publicaciones y cantidad de reacciones
-- ============================================================

CREATE OR REPLACE VIEW vw_publicaciones_reacciones AS
SELECT
    p.id_publicacion AS codigo_publicacion,
    p.titulo AS titulo_publicacion,
    e.nombre || ' ' || e.apellido AS nombre_autor,
    p.tipo_publicacion AS tipo_publicacion,
    COUNT(r.id_reaccion) AS total_reacciones
FROM publicacion p
INNER JOIN estudiante e
    ON p.id_estudiante = e.id_estudiante
LEFT JOIN reaccion r
    ON p.id_publicacion = r.id_publicacion
GROUP BY
    p.id_publicacion,
    p.titulo,
    e.nombre,
    e.apellido,
    p.tipo_publicacion;


-- ============================================================
-- Vista N°3:
-- Participación de estudiantes en grupos
-- ============================================================

CREATE OR REPLACE VIEW vw_participacion_grupos AS
SELECT
    g.id_grupo AS codigo_grupo,
    g.nombre AS nombre_grupo,
    g.descripcion AS descripcion_grupo,
    COUNT(m.id_estudiante) AS cantidad_miembros
FROM grupo g
LEFT JOIN membresia m
    ON g.id_grupo = m.id_grupo
GROUP BY
    g.id_grupo,
    g.nombre,
    g.descripcion;

