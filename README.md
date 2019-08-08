# Temperature logger
Perl script that reads the value of a DS18B20 temperature sensor and writes it to a database using a Raspberry Pi.

## Wiring Instruction
| DS18B20        | Raspberry Pi  | 4,7 kOhm Resistor |
|:-------------- |:------------- |:----------------- |
| V (Red)        | 3.3V          | NC                |
| Data (Yellow)  | GPIO4         | Connected         |
| Ground (Black) | Ground        | Connected         |
