# Up-Down Counter Project

## Project Overview

This project implements an up-down counter using the Zybo Z7-10 FPGA board and a two-digit seven-segment display.  
The counter counts from 00 to 99 in "Up" mode and from 99 down to 00 in "Down" mode based on the state of a user switch.  
The project demonstrates clock division, button debouncing, switch control, and seven-segment display multiplexing.

## How It Works

- The counter starts at 00 when powered on and waits for a button press.
- When the "Start" button is pressed, the counter begins counting.
- If the switch (`sw`) is set to 0, the counter counts upward from 00 to 99.
- When reaching 99, the counter rolls over back to 00 and pauses until the next button press.
- If the switch (`sw`) is set to 1, the counter counts downward from 99 to 00.
- When reaching 00 in down mode, the counter rolls over back to 99 and pauses until the next button press.
- At any time, pressing the "Reset" button immediately resets the counter to the starting value based on the current mode (00 for Up mode, 99 for Down mode).

## Features

- Debounced button inputs for both the start and reset buttons.
- Switchable counting direction between Up and Down modes.
- Seven-segment display multiplexing for a two-digit display (right digit and left digit).
- Clock division logic to create a slower counting rate suitable for human observation.

## Controls

| Control | Function |
|:--------|:---------|
| Start Button (`start_btn`) | Starts the counter in the current mode |
| Reset Button (`rst_btn`) | Resets the counter to 00 (Up) or 99 (Down) |
| Switch (`sw`) | Selects counting mode: Up (`sw=0`) or Down (`sw=1`) |

## Hardware Requirements

- Digilent Zybo Z7-10 FPGA Board
- Digilent Seven Segment Display Pmod connected to Pmod headers
- Two push-buttons for Start and Reset
- One switch for Up/Down mode selection


