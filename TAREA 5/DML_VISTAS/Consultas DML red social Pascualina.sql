
-- ============================================================
-- PROYECTO: Red social Pascualina
-- Consulta DML de la tarea N°5
-- SGBD: postgreSQL
-- ============================================================

/* OBJETIVO:
El Objetivo de estas Consultas es validar la informacion registrada 
de los estudiantes, sus publicaciones, comentarios, 
intereses, reacciones y sus grupos de la red social Pascualina*/

-- ============================================================
-- Consulta N°1:
-- Publicaciones y comentarios de otras personas
-- ============================================================

SELECT
    autor.nombre || ' ' || autor.apellido AS nombre_autor,
    p.titulo AS titulo_publicacion,
    comentarista.nombre || ' ' || comentarista.apellido AS nombre_comentarista,
    c.contenido AS comentario_realizado
FROM publicacion p
INNER JOIN estudiante autor
    ON p.id_estudiante = autor.id_estudiante
INNER JOIN comentario c
    ON p.id_publicacion = c.id_publicacion
INNER JOIN estudiante comentarista
    ON c.id_estudiante = comentarista.id_estudiante
WHERE c.id_estudiante <> p.id_estudiante
ORDER BY p.id_publicacion;


-- ============================================================
-- Consulta N°2:
-- Estudiantes sin interes registrados
-- ============================================================

SELECT
    e.id_estudiante AS codigo_estudiante,
    e.nombre AS nombre,
    e.apellido AS apellido,
    e.correo AS correo_electronico,
    e.carrera AS carrera
FROM estudiante e
LEFT JOIN estudiante_interes ei
    ON e.id_estudiante = ei.id_estudiante
WHERE ei.id_estudiante IS NULL
ORDER BY e.apellido;


-- ============================================================
-- Consulta N°3:
-- Carrreras con mas de dos estudiantes
-- ============================================================

SELECT
    carrera AS nombre_carrera,
    COUNT(*) AS total_estudiantes
FROM estudiante
GROUP BY carrera
HAVING COUNT(*) > 2
ORDER BY total_estudiantes DESC;


-- ============================================================
-- Consulta N° 4:
-- Publicaciones con reacciones superiores al promedio
-- ============================================================

WITH cantidad_por_publicacion AS (
    SELECT
        p.id_publicacion,
        p.titulo,
        COUNT(r.id_reaccion) AS total_reacciones
    FROM publicacion p
    LEFT JOIN reaccion r
        ON p.id_publicacion = r.id_publicacion
    GROUP BY p.id_publicacion, p.titulo
),
promedio_general AS (
    SELECT AVG(total_reacciones) AS promedio_reacciones
    FROM cantidad_por_publicacion
)
SELECT
    cp.id_publicacion AS codigo_publicacion,
    cp.titulo AS titulo_publicacion,
    cp.total_reacciones AS cantidad_reacciones,
    ROUND(pg.promedio_reacciones, 2) AS promedio_general
FROM cantidad_por_publicacion cp
CROSS JOIN promedio_general pg
WHERE cp.total_reacciones > pg.promedio_reacciones
ORDER BY cp.total_reacciones DESC;


-- ============================================================
-- Consulta N°5:
-- Grupos con mayor participación estudiantil
-- ============================================================

SELECT
    g.id_grupo AS codigo_grupo,
    g.nombre AS nombre_grupo,
    COUNT(m.id_estudiante) AS cantidad_miembros
FROM grupo g
LEFT JOIN membresia m
    ON g.id_grupo = m.id_grupo
GROUP BY g.id_grupo, g.nombre
ORDER BY cantidad_miembros DESC, g.nombre;


