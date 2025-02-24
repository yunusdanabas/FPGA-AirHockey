# FPGA Air-Hockey: Digital Showdown

## Overview

This project implements a two-player electronic air-hockey game on an FPGA using a 5×5 digital playground. The game simulates a moving puck with LED arrays and displays coordinates and scores on seven-segment displays. The design was realized using Verilog and implemented on the Nexys A7 board. This repository contains all the source files, simulation testbenches, and supplementary modules needed for the project.

## Features

- **Two-Player Game:** Designed for players on opposite sides of the board using dedicated buttons and switches.
- **Dynamic Gameplay:** The puck moves across a 5×5 grid with variable speed settings. Players can adjust puck speed (0.5s and 1s per step) and even customize the number of goals required to win.
- **Real-Time Display:** Uses LED arrays to simulate puck movement and seven-segment displays to show puck coordinates and scores.
- **Robust Design:** Integrates essential modules such as a clock divider, debouncer, and SSD (seven-segment display) driver.
- **FPGA Implementation:** Fully demonstrated on the Nexys A7 board with supporting constraint files and documentation.

## Project Structure

- **Phase 1:**  
  - Design diagrams and state flow (see *Phase1.pdf*)  
- **Phase 2:**  
  - Core game logic implemented in Verilog (e.g., *hockey.v*, *hockey_tb.v*, and simulation files)
- **Phase 3:**  
  - Additional modules and templates:  
    - Clock divider (*clk_divider.v*)  
    - Debouncer (*debouncer.v*)  
    - Seven-segment display driver (*ssd.v*)  
    - Top module template (*top_module - template.v*)  
  - Supporting files such as constraint files (*project.xdc*)  
- **Supplementary Assets:**  
  - Gameplay video (*Gameplay.mp4*)  
  - FPGA board image (*Board.jpg*)  
  - Nexys A7 Reference Manual (*nexys-a7_rm.pdf*)

## How It Works

1. **Initialization:**  
   Upon starting, the game displays the initial score (0-0) and waits for Player A’s input.
2. **Game Play:**  
   - **Player Input:** Each player uses their dedicated button (BTNL for Player A, BTNR for Player B) along with slide switches to choose the puck’s trajectory.
   - **Puck Movement:** The game simulates puck motion across the board, with LED columns lighting up sequentially to represent movement.
   - **Scoring:** If a player fails to hit the puck in time or chooses an invalid coordinate, the other player scores a point. The game displays the current score and indicates the next turn.
3. **Winning Condition:**  
   The game concludes when a player scores 3 goals (or a user-defined goal limit). The final score and winning player are displayed, and the LEDs flash to signal the win.

## Setup & Usage

1. **Simulation:**  
   - Use the provided testbench (*hockey_tb.v*) to simulate the game logic.
   - Verify timing and state transitions in your simulation environment.

2. **FPGA Implementation:**  
   - Synthesize the design using Xilinx Vivado (or the recommended toolchain for Nexys A7).
   - Ensure the constraint file (*project.xdc*) is correctly set for the Nexys A7 board.
   - Program the FPGA and observe the game demo using the on-board LEDs, switches, and seven-segment displays.

## Demo

A gameplay video (*Gameplay.mp4*) is included in this repository to showcase the game in action. Additionally, the attached board image (*Board.jpg*) illustrates the FPGA implementation setup.

## Acknowledgments

- **Course:** Logic & Digital System Design – Fall 2023-2024  
- **Instructor :** Atıl Utku Ay
