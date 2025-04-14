# Santiago Sanchez
# SimpleUART Boot.py
# Creates a separate COM Port to allow transfer of Binary data
# without interference from REPL

import usb_cdc

usb_cdc.enable(console=True, data=True)

    
