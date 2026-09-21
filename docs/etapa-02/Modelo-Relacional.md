# De Diagrama Entidad-Relación (DER) a Modelo Relacional


## 1. Reglas de Transformación del DER al Modelo Relacional

---

### Regla 1: Entidades Fuertes → Tablas

**Cada entidad fuerte del DER se convierte en una tabla**

#### Proceso:
1. El nombre de la entidad se convierte en el nombre de la tabla
2. Los atributos de la entidad se convierten en columnas
3. El atributo identificador (subrayado en el DER) se convierte en clave primaria (PK)

---

### Regla 2: Entidades Débiles → Tablas Dependientes

**Una entidad débil se convierte en una tabla que depende de su entidad fuerte**

#### Características:
- La tabla hereda la clave primaria de su entidad fuerte como clave foránea
- La clave primaria es compuesta: (FK de entidad fuerte + atributo discriminador)

---

### Regla 3: Relaciones 1:1 → Integración en una tabla

**Si la relación es 1:1, se puede integrar la clave foránea en una de las tablas**

#### Opciones:
- Incluir la FK en la tabla del lado obligatorio
- O crear una tabla intermedia (menos común)

---

### Regla 4: Relaciones 1:N → Clave Foránea en tabla "muchos"

**La clave foránea se añade en la tabla del lado N (muchos) de la relación**

#### Proceso:
1. Identificar qué lado es 1 y qué lado es N
2. Copiar la PK del lado 1 hacia la tabla del lado N
3. Esta FK en la tabla N mantiene la referencia

---

### Regla 5: Relaciones M:N → Tabla de Unión

**Una relación muchos-a-muchos (M:N) se convierte en una tabla intermedia**

#### Proceso:
1. Crear una nueva tabla con el nombre de la relación (o combinación de nombres)
2. Las claves primarias de ambas entidades se convierten en claves foráneas
3. La PK de la tabla de unión es compuesta (ambas FKs)
4. Se incluyen los atributos de la relación

---

### Regla 6: Atributos Multivaluados → Tabla Separada

**Un atributo que puede tener múltiples valores se convierte en una tabla**

#### Proceso:
1. Crear una nueva tabla para el atributo multivaluado
2. Incluir la clave foránea hacia la entidad propietaria
3. Incluir el atributo multivaluado como dato

---

## 2. Transformación Completa del Proyecto

### DER Original
El DER incluye las siguientes entidades:
- **Cliente** (fuerte)
- **Empleado** (fuerte) con relación débil **Puesto_laboral**
- **Producto** (fuerte)
- **Proveedor** (fuerte)
- **Venta_Factura** (entidad de relación)
- **Tipo_producto** (entidad compuesta)
- **Tipo_factura** (entidad compuesta)
- **Método_pago** (entidad de compuesta)

### Transformación a Modelo Relacional

#### Paso 1: Entidades Fuertes → Tablas

#### Paso 2: Entidades Débiles → Tablas Dependientes

#### Paso 3: Entidades de Apoyo/Categoría → Tablas de Referencia

#### Paso 4: Relaciones 1:N → FKs en tabla "muchos"

#### Paso 5: Relaciones M:N → Tabla de Unión

#### Paso 6: Resultado Final - Tablas en Modelo Relacional

---

## Conclusión

La transformación del DER al modelo relacional es un proceso sistemático que sigue reglas bien definidas. Estas reglas aseguran que la base de datos resultante sea:

1. Coherente: Mantiene la semántica del modelo original
2. Funcional: Soporta todas las operaciones requeridas
3. Preparada para normalización: Puede ser optimizada aún más

Una vez aplicadas estas reglas, el modelo relacional está listo para ser normalizado, eliminando redundancias y dependencias no deseadas.
