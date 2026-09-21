# Normalización de Bases de Datos: 1FN, 2FN y 3FN

## 1. Primera Forma Normal (1FN)

### Definición

**Una tabla está en 1FN si todos sus atributos contienen valores atómicos.**

En otras palabras:
- No hay atributos multivaluados
- No hay atributos compuestos
- Cada celda contiene un único valor
- No hay grupos repetidos

### Paso a Paso: Aplicar 1FN al Proyecto

#### Paso 1: Identificar atributos multivaluados
- NumTel contiene múltiples valores separados por comas

#### Paso 2: Separar en tablas atómicas

#### Resultado: 1FN
- Cada celda contiene un único valor
- Los datos están distribuidos en filas separadas

---

## 2. Segunda Forma Normal (2FN)

### Definición

Una tabla está en 2FN si:
1. Está en 1FN 
2. Todo atributo no-clave depende funcionalmente de toda la clave primaria (no solo de parte de ella)

En otras palabras: elimina dependencias

### Paso a Paso: Aplicar 2FN al Proyecto

#### Paso 1: Separar dependencias parciales en puesto_laboral

#### Paso 2: Establecer relaciones

#### Resultado: 2FN 
- No hay dependencias parciales
- "Gerente General" aparece una sola vez
- Fácil de actualizar

---

## 3. Tercera Forma Normal (3FN)

### Definición

Una tabla está en 3FN si:
1. Está en 2FN
2. No hay dependencias transitivas de atributos no-clave

En otras palabras: todo atributo no-clave depende directamente de la clave primaria, no de otro atributo no-clave.

### Paso a Paso: Aplicar 3FN al Proyecto

nombre_tipo_producto depende transitivamente a traves de id_tipo

#### Paso 1: Crear tabla para el atributo transitivo

#### Paso 2: Eliminar el atributo transitivo de la tabla original

#### Paso 3: Establecer la relación

#### Resultado: 3FN 
- No hay dependencias transitivas
- "Informática" aparece una sola vez
- Estructura clara y mantenible

## Conclusión

La normalización es un proceso **sistemático** que transforma una base de datos llena de redundancias en una estructura limpia, eficiente e íntegra.

### Las tres bases:

1FN: Elimina atributos multivaluados: Atomicidad.

2FN: Elimina dependencias parciale: Integridad en claves compuestas.

3FN: Elimina dependencias transitividades: Independencia de atributos.

### Resultado Final:

Menos redundancia

Menos anomalías


