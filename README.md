# ⏰ Relógio Digital em Assembly e C++ (ATmega328P)

Este projeto implementa um relógio digital completo no microcontrolador **ATmega328P**, utilizando uma combinação de Assembly (para lógica de tempo) e C++ (para manipulação de LCD e periféricos). O projeto é desenvolvido no **Microchip Studio** e pode ser simulado no **SimulIDE**.

## 🧩 Funcionalidades

- 🕒 Contador de horas, minutos e segundos
- ✏️ Edição manual do tempo (hora, minuto, segundo)
- ⏱️ Modo cronômetro regressivo com LED de alarme
- 🔁 Controle de direção (incremento/decremento)
- 📟 Interface com display LCD 16x2
- 🧲 Controle via botões físicos com interrupções (PCINT)

## 🎛️ Modos de Operação (via variável EDIT)

| EDIT | Função                           |
|------|--------------------------------- |
| 0    | Contagem normal (incrementa)     |
| 1    | Edição de segundos               |
| 2    | Edição de minutos                |
| 3    | Edição de horas                  |
| 4    | Modo cronômetro regressivo       |

## 🛠️ Requisitos

- **Microcontrolador:** ATmega328P
- **IDE:** Microchip Studio
- **Display:** LCD 16x2 (modo 4 bits)
- **Botões físicos:** 3 (skip, up, down)
- **LED de alarme:** 1
- **Simulação:** SimulIDE (usando arquivos `.sim1`)
