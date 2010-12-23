" Copyright (c) 2010, Tatsuya Akagi
" All rights reserved.
"
" Redistribution and use in source and binary forms,
" with or without modification,
" are permitted provided that the following conditions are met:
"
" * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
" * Redistributions in binary form must reproduce the above copyright notice,
" this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
" * Neither the name of the RedM Studio nor the names of its contributors may be used to endorse
" or promote products derived from this software without specific prior written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
" INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
" IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
" OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
" LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
" WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
" ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"
" Description
" =============
"      this vim plugin sends selected string in visual mode as Maya command(MEL or python) to running Maya.
"    
" Require
" =============
"     python(using in vim ) 
"
" Ready
" =============
"     you need open message port in maya.: commandPort -n :8383;(optional port number)
"
" Key mapping
" =============
" ex.)
" vmap <c-m> :Vim2Maya<cr>
" vmap <c-y> :Vim2MayaPython<cr>
"
" Setting
" ===============
let s:tempPath = "C:/temp/"
let s:port     = "8383"
" ==============

function! s:GetSelRange()
	:let tmp = @@
	:silent normal gvy
	:let selected = @@
	:let @@ = tmp
	return selected
endfunction

function! s:Vim2Maya(mode) range
python << EOF
import socket
import sys, vim, string

tempPath = vim.eval('s:tempPath')
port = int(vim.eval('s:port'))

mode = vim.eval('a:mode')

tempFile = "v2m.mel"
if mode == "mel":
	tempFile = "v2m.mel"
elif mode  == "python":
	tempFile = "v2m.py"

fileId = open(tempPath + tempFile,"w")
fileId.write(vim.eval("s:GetSelRange()"))
fileId.close()

# output to Maya
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('localhost', port))
if mode == "mel":
	s.send("source \""+tempPath+tempFile+"\"")
elif mode == "python":
	s.send("python(\"execfile('"+tempPath+tempFile+"')\")")
s.close()
EOF
endfunction

:command! -range -narg=0 Vim2Maya :<line1>,<line2>call s:Vim2Maya("mel")
:command! -range -narg=0 Vim2MayaPython :<line1>,<line2>call s:Vim2Maya("python")
