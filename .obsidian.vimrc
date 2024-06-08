" Obsidian Vimrc Support Plugin: https://github.com/esm7/obsidian-vimrc-support

" Symlink to this file in your Obsidian vault root:
" $ cd $YOUR_OBSIDIAN_VAULT
" $ ln -s ~/.obsidian.vimrc

" 0 moves tothe first non-whitespace character in a line
nmap 0 ^

" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk

" Navigate history back/forward with Alt-h and Alt-l
exmap back obcommand app:go-back
nunmap <A-h>
nmap <A-h> :back<CR>
exmap fwd obcommand app:go-forward
nunmap <A-l>
nmap <A-l> :fwd<CR>

" Surround text
vunmap S
exmap surround_double_quotes surround " "
vmap S" :surround_double_quotes<CR>
exmap surround_single_quotes surround ' '
vmap S' :surround_single_quotes<CR>
exmap surround_backticks surround ` `
vmap S` :surround_backticks<CR>
exmap surround_parentheses surround ( )
vmap S) :surround_parentheses<CR>
exmap surround_square_brackets surround [ ]
vmap S] :surround_square_brackets<CR>
exmap surround_curly_brackets surround { }
vmap S} :surround_curly_brackets<CR>
exmap surround_pointy_brackets surround < >
vmap S> :surround_pointy_brackets<CR>

" Folding
exmap fm obcommand editor:fold-more
nmap zc :fm<CR>
exmap fl obcommand editor:fold-less
nmap zo :fl<CR>

" Tabs
exmap close_tab obcommand workspace:close
nmap ZZ :close_tab<CR>

