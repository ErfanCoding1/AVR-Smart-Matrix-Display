# AVR Smart Matrix Display 

This repository contains the firmware and hardware design for a multi-stage LED matrix project.

## Phase 1: Scrolling Text (Current)
- Implementation of **SPI Protocol** for 8x cascaded MAX7219 drivers.
- Bit-masking logic to render custom alphanumeric fonts.
- Efficient buffer shifting for smooth scrolling animations.

## Hardware Setup
- **MCU:** ATmega328P (8MHz)
- **Display:** 8x (8x8 LED Matrix)
- **Driver:** MAX7219 (Daisy-chained)

## Project Structure
- `/01-Scrolling-Text`: Source code and Proteus simulation.
- `/Shared-Drivers`: Core SPI and MAX7219 initialization logic.
