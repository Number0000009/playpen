TODO:
0) Convert graphics in 'incoming_assets' and use it for scroller background
1) Add 'Happy Birthday!' sprites with shadow on top and bottom
Probably this should be done with CPU as BLiTTER is already 146% busy
2) Add vines to the sides

DONE 1) Music player + music. Requires ICE! unpacker
DONE 2) Make background scroller accelerate/decelerate by sin
DONE 2.1) Add start position for scroller
DONE 2.2) Add sin generator/table

PROBLEMS:
1) Background scroller dosn't fit into VBL.
Possibly reduce width to 72 words per scanline.

2) Graceful exit
