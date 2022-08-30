TODO:
1) Make sprites pixel-precise
2) Add mask to sprites

DONE 1) Music player + music. Requires ICE! unpacker
DONE 2) Make background scroller accelerate/decelerate by sin
DONE 2.1) Add start position for scroller
DONE 2.2) Add sin generator/table
DONE 3) Convert graphics in 'incoming_assets' and use it for scroller background
DONE 4) Add vines to the sides
DONE 5) Add 'Happy Birthday!' sprites flying by sin/cos

PROBLEMS:
1) Background scroller dosn't fit into VBL.
Possibly reduce width to 72 words per scanline.

2) Graceful exit
