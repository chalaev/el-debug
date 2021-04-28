
# Table of Contents

1.  [Description](#orge86e4e8)
2.  [Prerequisites](#org46e7140)
3.  [Quick start](#org2157bc9)
4.  [License](#org2128d66)


<a id="orge86e4e8"></a>

# Description

Simplifies elisp debugging and testing.

Usage example: take a look on how it is used in [testing cloud project](https://github.com/chalaev/cloud/blob/master/testing.org):
`(require 'el-debug)` rewrites `defun` so that we get a log message every time we enter or leave a function,
see [meso.log](https://github.com/chalaev/cloud/blob/master/tests/meso.log) as an example.

Other macros used for debugging in [cloud project](https://github.com/chalaev/cloud): [cloud.org](https://github.com/chalaev/cloud/blob/master/cloud.org) and [testing.org](https://github.com/chalaev/cloud/blob/master/testing.org):
`debug-set`, `set-list`, and `debug-log-var`.


<a id="org46e7140"></a>

# Prerequisites

We need [lisp-goodies](https://github.com/chalaev/lisp-goodies): [start.el](https://github.com/chalaev/lisp-goodies/blob/master/packaged/start.el) (used by [Makefile](Makefile)), and [shalaev.el](https://github.com/chalaev/lisp-goodies/blob/master/packaged/shalaev.el) for logging.


<a id="org2157bc9"></a>

# Quick start

1.  `mkdir ~/.emacs.d/local-packages/`.
2.  Place [shalaev.el](https://github.com/chalaev/lisp-goodies/blob/master/packaged/shalaev.el) and [el-debug.el](packaged/el-debug.el) to `~/.emacs.d/local-packages/`
3.  Load [start.el](https://github.com/chalaev/lisp-goodies/blob/master/packaged/start.el) in your [~/.emacs](https://github.com/chalaev/lisp-goodies/blob/master/generated/dot.emacs)
4.  Insert in your text code:
    
        (require 'el-debug)
    
    similarly to [this example](https://github.com/chalaev/cloud/blob/master/testing.org).


<a id="org2128d66"></a>

# License

This code is released under [MIT license](https://mit-license.org/).

