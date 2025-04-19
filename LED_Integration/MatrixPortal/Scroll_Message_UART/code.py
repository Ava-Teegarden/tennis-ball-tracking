# SPDX-FileCopyrightText: 2020 Jeff Epler for Adafruit Industries
#
# SPDX-License-Identifier: MIT

# This example implements a simple two line scroller using
# Adafruit_CircuitPython_Display_Text. Each line has its own color
# and it is possible to modify the example to use other fonts and non-standard
# characters.

import adafruit_display_text.label
import board
import displayio
import framebufferio
import rgbmatrix
import terminalio
import busio

import random
import time

import array

from rainbowio import colorwheel

# If there was a display before (protomatter, LCD, or E-paper), release it so
# we can create ours
displayio.release_displays()

# This next call creates the RGB Matrix object itself. It has the given width
# and height. bit_depth can range from 1 to 6; higher numbers allow more color
# shades to be displayed, but increase memory usage and slow down your Python
# code. If you just want to show primary colors plus black and white, use 1.
# Otherwise, try 3, 4 and 5 to see which effect you like best.
#
# These lines are for the Feather M4 Express. If you're using a different board,
# check the guide to find the pins and wiring diagrams for your board.
# If you have a matrix with a different width or height, change that too.
# If you have a 16x32 display, try with just a single line of text.
# Initialize display
matrix = rgbmatrix.RGBMatrix(
    width=64, bit_depth=4,
    rgb_pins=[
        board.MTX_R1,
        board.MTX_G1,
        board.MTX_B1,
        board.MTX_R2,
        board.MTX_G2,
        board.MTX_B2
    ],
    addr_pins=[
        board.MTX_ADDRA,
        board.MTX_ADDRB,
        board.MTX_ADDRC,
        board.MTX_ADDRD
    ],
    clock_pin=board.MTX_CLK,
    latch_pin=board.MTX_LAT,
    output_enable_pin=board.MTX_OE
)
display = framebufferio.FramebufferDisplay(matrix)

# SPDX-FileCopyrightText: 2020 Jeff Epler for Adafruit Industries
#
# SPDX-License-Identifier: MIT

# This example implements a rainbow colored scroller, in which each letter
# has a different color. This is not possible with
# Adafruit_Circuitpython_Display_Text, where each letter in a label has the
# same color
#
# This demo also supports only ASCII characters and the built-in font.
# See the simple_scroller example for one that supports alternative fonts
# and characters, but only has a single color per label.

# Create a tilegrid with a bunch of common settings
def tilegrid(palette):
    return displayio.TileGrid(
        bitmap=terminalio.FONT.bitmap, pixel_shader=palette,
        width=1, height=1, tile_width=6, tile_height=12, default_tile=32)

g = displayio.Group()

# We only use the built in font which we treat as being 7x14 pixels
linelen = (64//7)+2

# prepare the main groups
l1 = displayio.Group()
l2 = displayio.Group()
g.append(l1)
g.append(l2)
display.root_group = g

l1.y = 1
l2.y = 16

# Prepare the palettes and the individual characters' tiles
sh = [displayio.Palette(2) for _ in range(linelen)]
tg1 = [tilegrid(shi) for shi in sh]
tg2 = [tilegrid(shi) for shi in sh]

# Prepare a fast map from byte values to
charmap = array.array('b', [terminalio.FONT.get_glyph(32).tile_index]) * 256
for ch in range(256):
    glyph = terminalio.FONT.get_glyph(ch)
    if glyph is not None:
        charmap[ch] = glyph.tile_index

# Set the X coordinates of each character in label 1, and add it to its group
for idx, gi in enumerate(tg1):
    gi.x = 7 * idx
    l1.append(gi)

# Set the X coordinates of each character in label 2, and add it to its group
for idx, gi in enumerate(tg2):
    gi.x = 7 * idx
    l2.append(gi)

#  These pairs of lines should be the same length
lines = [
    b"       BALL IN!        ",
    b"***********************",
    b"      BALL OUT!        ",
    b"***********************",

]

even_lines = lines[0::2]
odd_lines = lines[1::2]

# Scroll a top text and a bottom text
def scroll(t, b):
    # Add spaces to the start and end of each label so that it goes from
    # the far right all the way off the left
    sp = b' ' * linelen
    t = sp + t + sp
    b = sp + b + sp
    maxlen = max(len(t), len(b))
    # For each whole character position...
    for i in range(maxlen-linelen):
        # Set the letter displayed at each position, and its color
        for j in range(linelen):
            sh[j][1] = colorwheel(3 * (2*i+j))
            tg1[j][0] = charmap[t[i+j]]
            tg2[j][0] = charmap[b[i+j]]
        # And then for each pixel position, move the two labels
        # and then refresh the display.
        for j in range(7):
            l1.x = -j
            l2.x = -j
            display.refresh(minimum_frames_per_second=0)

# Connect to TX, & RX Pins w/ specified Baud Rate
uart = busio.UART(board.TX, board.RX, baudrate=9600)

# Repeatedly scroll all the pairs of lines
while True:
    # Read one byte of data
    data = uart.read(1)

    if data != None:
        # Convert bytes into data format
        val = int.from_bytes(data,byteorder='little',signed=False)

        if val == 1:
            #for e, o in zip(even_lines, odd_lines):
            scroll(even_lines[0], odd_lines[0])
        else:
            scroll(even_lines[1], odd_lines[1])


