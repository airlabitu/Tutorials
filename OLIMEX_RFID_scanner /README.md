## Reading RFID tags in Processing with the OLIMEX MOD-RFID125 scanner

### Needed to run this example
- 1 x OLIMEX MOD-RFID125 scanner
- A labtop with Processing installed (https://processing.org/download/)
- 4 x RFID (125 kHz) cards/tags

#### NB: One card/tag is enough to make it work, but you wont be able to see the full code work

### Trying it out
1) Download and unzip the Processing example code [MOD_RFID125_reader](https://github.com/airlabitu/Tutorials/tree/master/OLIMEX_RFID_scanner%20/MOD_RFID125_reader) from the [OLIMEX_RFID_scanner](https://github.com/airlabitu/Tutorials/tree/master/OLIMEX_RFID_scanner%20) folder our Turorials repository [link](https://github.com/airlabitu/Tutorials)
2) Attach the OLIMEX MOD-RFIS125 to your computer via USB. It will likely open a dialogue from your OS that tells you that a new keyboard is detected. Just close this dialogue.
3) Open a text editor, and scan a card/tag, while making sure to keep the text editor the active window. Now the ID of the given card/tag will appear in the text editor. 
4) Copy the code, and replace one of the IDs in the downloaded code (line: 10) with the one you just read from your card.
5) Run the code, and try to place a card/tag on top of the scanner, and remove it again.
6) A green square should now appear in one of the four corners of the sketch canvas.
7) Repeat the process with dumping and replacing RFID codes with the remaining three cards/tags, and run the sketch again.
8) Now try with different cards/tags. The green square should now move from corner to corner, each time a new card is scanned.

### DONE :-)