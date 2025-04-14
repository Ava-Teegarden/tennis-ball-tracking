# SPDX-FileCopyrightText: 2018 Kattni Rembor for Adafruit Industries
#
# SPDX-License-Identifier: MIT

"""CircuitPython Essentials UART Serial example"""
import board
import busio
import digitalio
import usb_cdc

console = usb_cdc.data
console.write(bytes(b"Hello World\n"))

while True:
    console.write(bytes(b"Hello World\n"))
    