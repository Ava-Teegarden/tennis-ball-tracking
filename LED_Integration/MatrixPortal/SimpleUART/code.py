# Santiago Sanchez 
# Simple UART Communication using TX & RX pins on
# Matrix Portal Board

"""CircuitPython Essentials UART Serial example"""
import board
import busio
import digitalio

uart = busio.UART(board.TX, board.RX, baudrate=9600)

while True:
    data = uart.read(8)  # read up to 32 bytes
    # print(data)  # this is a bytearray type

    if data is not None:

        # convert bytearray to string
        uart.write(data)


