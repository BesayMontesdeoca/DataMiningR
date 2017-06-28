# Asociación de Reglas

El objetivo de esta práctica es realizar un análisis sobre una base de datos utilizando técnicas de extracción de reglas de asociación (RAs).

## 1.Descripción y preprocesamiento de la base de datos

**a. Descripción.** <br />
El dataset que se utilizará para aplicar las distintas técnicas pertenecientes al apartado de las Reglas de Asociación fue extraído de  repositorio gratis UCI. Se intentó escoger una base de datos que recogiese información fácil de entender, es decir, se evitó escoger bases de datos donde se ha reunido información más compleja como por ejemplo la eritema, el fenómeno koebner, las pápulas foliculares como es en el caso del dataset Dermatology.<br />
En concreto la base de datos que se ha escogido se llama Student Performance, cuyos datos abordan el logro estudiantil de la educació  secundaria de dos escuelas portuguesas. Los atributos de los datos incluyen calificaciones de los estudiantes, características demográficas y sociales los cuales fueron recopilados mediante el uso de informes escolares y cuestionarios.

**b. Descripción de los atributos.**
La base de datos en un principio consta de 33 atributos que se describen a continuación:<br />
**school:** Escuela del estudiante (binario: "GP" - Gabriel Pereira o "MS" - Mousinho da Silveira)<br />
**sex:** Sexo del estudiante (binario: "F" - femenino "M" - masculino)<br />
**age:** Edad del estudiante (numérica: de 15 a 22)<br />
**address:** Tipo de domicilio del estudiante (binario: "U" - urbano o "R" - rural)<br />
**famsize:** Tamaño de la familia (binario: "LE3" - menor o igual a 3 o "GT3" - mayor que 3)<br />
**Pstatus:** Estado de cohabitación de los padres (binario: "T" - viven juntos o "A" - aparte)<br />
**Medu:** Educación de la madre (numérica: 0 - ninguna, 1 - educación primaria (4º grado), 2 - 5º a 9º grado, 3 - educación secundaria o 4 - educación superior)<br />
**Fedu:** Educación del padre (numérico: 0 - ninguno, 1 - educación primaria (4º grado), 2 - 5º al 9º grado, 3 - educación secundaria o 4 - educación superior)<br />
**Mjob:** Trabajo de la madre (nominal: "profesor", "cuidado de salud" relacionado, civil "servicios" (por ejemplo, administrativo o de policía), "en_casa" u "otro".<br />
**Fjob:** Trabajo del padre (nominal: "profesor", "cuidado de salud" relacionado, civil "servicios" (por ejemplo, administrativo o policía), "en_casa" u "otro")<br />
**reason:** Razón de la elección de dicha escuela (nominal: cerca de "casa", "reputación", "curso" u "otro")<br />
**guardian:** Tutor del estudiante (nominal: "madre", "padre" o "otro")<br />
**traveltime:** Tiempo que tarda el alumno desde su casa a la escuela (numérico: 1 - <15 min, 2 - 15 a 30 min, 3 - 30 min a 1 hora, o 4 -> 1 hora)<br />
**studytime:** Tiempo de estudio semanal (numérico: 1 - <2 horas, 2 - 2 a 5 horas, 3 - 5 a 10 horas, o 4 -> 10 horas)<br />
**failures:** Número de suspensos de clases anteriores (numérico: n si 1 <= n <3, si no 4)<br />
**schoolsup:** Apoyo educativo extra (binario: sí o no)<br />
**famsup:** Apoyo educativo familiar (binario: sí o no)<br />
**paid:** Clases extra dentro del curso (binario: sí o no)<br />
**activities:** Actividades extra-curriculares (binario: sí o no)<br />
**nursery:** Asistió a la guardería (binario: sí o no)<br />
**higher:** Quiere cursar una educación superior (binario: sí o no)<br />
**internet:** Acceso a Internet en casa (binario: sí o no)<br />
**romantic:** Con una relación romántica (binario: sí o no)<br />
**famrel:** Calidad de las relaciones familiares (numérico: de 1 - muy malo a 5 - excelente)<br />
**freetime:** Tiempo libre después de la escuela (numérico: de 1 - muy bajo a 5 - muy alto)<br />
**goout:** Salida con amigos (numérico: de 1 - muy bajo a 5 - muy alto)<br />
**Dalc:** Consumo de alcohol durante el día de trabajo (numérico: de 1 - muy bajo a 5 - muy alto)<br />
**Walc:** Consumo de alcohol durante el fin de semana (numérico: de 1 - muy bajo a 5 - muy alto)<br />
**health:** situación de salud actual (numérica: de 1 - muy mala a 5 - muy buena)<br />
**absences:** Número de ausencias escolares (numérico: de 0 a 93)<br />
**G1:** Nota del primer periodo (numérica: De 0 a 20)<br />
**G2:** Nota del segundo periodo (numérica: De 0 a 20)<br />
**G3:** Nota final (numérica: De 0 a 20)<br />

Para aplicar las distintas técnicas no se trabajará con la totalidad de los atributos, se descartarán aquellos que de primeras parece que no ofrecen información útil y relevante. Por ejemplo en este caso se eliminaron los atributos school, failures, reason, paid, G1 y G2 (se ha dejado G3 puesto que representa el rendimiento final del alumno).

![alt tag](https://github.com/BesayMontesdeoca/DataMiningR/blob/master/AsociacionReglas/itemsetsFrecuentes.PNG)
