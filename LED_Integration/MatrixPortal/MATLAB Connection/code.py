# Santiago Sanchez 
# Simple UART Communication using TX & RX pins on
# Matrix Portal Board

"""CircuitPython Essentials UART Serial example"""
import board
import busio
import digitalio

# Connect to TX, & RX Pins w/ specified Baud Rate
uart = busio.UART(board.TX, board.RX, baudrate=9600)

while True:
    # Read one byte of data
    data = uart.read(1) 
    
    # Wait for data to be received
    if data != None:

        # Convert bytes into data format
        val = int.from_bytes(data)  
        if val == 1:
            print("Hello World")
        else:
            print("Balls")


