## Reading RFID tags in Processing with the OLIMEX MOD-RFID125 scanner

### Needed to run this example
- 1 x OLIMEX MOD-RFID125 scanner
- A labtop with Processing installed (https://processing.org/download/)
- 4 x RFID (125 kHz) cards/tags

#### NB: One card/tag is enough to make it work, but you wont be able to see the full code work

### Trying it out
- Download and unzip the Processing example code (MOD_RFID125_reader) from this repository
- Attach the OLIMEX MOD-RFIS125 to your computer via USB. It will likely open a dialogue from your OS that tells you that a new keyboard is detected. Just close this dialogue.
- Open a text editor, and scan a card/tag, while making sure to keep the text editor the active window. Now the ID of the given card/tag will appear in the text editor. 
- Copy the code, and replace one of the IDs in the downloaded code (line: 10) with the one you just read from your card.
- Run the code, and try to place a card/tag on top of the scanner, and remove it again.
- A green square should now appear in one of the four corners of the sketch canvas.
- Repeat the process with dumping and replacing RFID codes with the remaining three cards/tags, and run the sketch again.
- Now try with different cards/tags. The green square should now move from corner to corner, each time a new card is scanned.

### DONE :-)