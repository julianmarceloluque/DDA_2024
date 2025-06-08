# Proyecto FPGA: Control y Debug de Módulo Top con VIO e ILA

## 🎯 Objetivo

Desarrollar e implementar un sistema digital en Verilog que permita:

- Incluir módulos **VIO** (Virtual Input/Output) e **ILA** (Integrated Logic Analyzer) para control y depuración del módulo `Top`.
- Validar el comportamiento del sistema mediante testbench y análisis en la FPGA.

---

## 📦 Descripción del Diseño

### Señales de Entrada (entradas marcadas en rojo en la consigna)

- `i_reset`: Reset del sistema. Pone a cero el contador e inicializa el registro de desplazamiento (SR).
- `i_sw[0]`: Controla el **enable** del contador. Si está en `0`, detiene el funcionamiento pero conserva los valores actuales.
- `i_sw[2:1]`: Selecciona el **límite de cuenta** del contador. Puede cambiarse en cualquier momento.
- `i_sw[3]`: Selecciona el **color de los LEDs RGB**.

### Comportamiento

- El **registro de desplazamiento (SR)** solo se desplaza cuando el contador alcanza el límite seleccionado.
- El **contador** se activa con `i_sw[0]` en `1`.

---

## 🧩 Módulos Verilog

| Archivo         | Descripción                               |
| --------------- | ----------------------------------------- |
| `top.v`         | Módulo principal del sistema              |
| `wrapper_top.v` | Instancia de VIO e ILA conectados a `top` |
| `count.v`       | Módulo de contador parametrizable         |
| `shiftreg.v`    | Registro de desplazamiento sincronizado   |
| `tb_top.v`      | Testbench para validar el comportamiento  |

---

## 🛠️ Testbench

El archivo `tb_top.v` contiene una simulación funcional sin uso de IP cores. Valida el comportamiento esperado del sistema bajo diferentes condiciones de entrada, como:

- Activación y desactivación del contador
- Selección de diferentes límites de cuenta
- Reset del sistema

### ✅ Resultados esperados en simulación:

- El SR se desplaza solo en coincidencia con los límites alcanzados.
- El estado del contador y SR se mantiene si el enable (`i_sw[0]`) se desactiva.
- El reset devuelve todo a su estado inicial.

📸 Se incluyen capturas de pantalla de la simulación mostrando las formas de onda esperadas.

---

## 🔌 Implementación en FPGA

Se utilizó el entorno **Vivado** para:

- Instanciar los IP cores de **VIO** e **ILA** en el archivo `wrapper_top.v`.
- Realizar la **síntesis**, **implementación**, y **programación** en la placa FPGA.

### Capturas:

- ✅ Captura del VIO mostrando entradas de control y valores observados.
- ✅ Captura del ILA mostrando el comportamiento del contador y SR en tiempo real.

---

## 📂 Estructura de Archivos
