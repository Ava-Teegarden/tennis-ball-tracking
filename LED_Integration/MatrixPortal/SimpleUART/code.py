# Santiago Sanchez
# Simple UART Code that writes to console 

"""CircuitPython Essentials UART Serial example"""
import usb_cdc

console = usb_cdc.data
console.write(bytes(b"Hello World\n"))

while True:
    console.write(bytes(b"Hello World\n"))
    