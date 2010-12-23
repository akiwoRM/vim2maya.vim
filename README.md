vim2maya.vim
=============

 vim2maya.vim is vim plugin sending maya command (MEL or Python) from vim to running Maya.

how to use
-----------
1. put 'vim2maya.vim' into your vim plugin folder.

2. select maya command in visual mode.
 ex.) sphere
3. execrate next command in command mode.

 if you want to send MEL command

    :vim2Maya

 if you want to send MayaPython command

    :vim2MayaPython

Key mapping
------------

ex.)

    vmap <c-m> :Vim2Maya<cr>
    vmap <c-y> :Vim2MayaPython<cr>
