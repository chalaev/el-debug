SHELL = /bin/bash
EMACS = emacs -q --no-site-file --batch

packaged/el-debug.el: version.org generated/from/el-debug.org header.el packaged/ README.md
	sed "s/the-version/`head -n1 $<`/" header.el > $@
	cat generated/el-debug.el >> $@
	echo -e "\n(provide 'el-debug)" >> $@
	echo ";;; el-debug.el ends here" >> $@
	emacsclient -e '(untilde (cdr (assoc "local-packages" package-archives)))' | xargs cp $@
	-@chgrp tmp $@

version.org: change-log.org
	emacsclient -e "(progn (require 'version) (format-version \"$<\"))" | sed 's/"//g' > $@
	@echo "← generated `date '+%m/%d %H:%M'` from [[file:$<][$<]]" >> $@
	@echo "by [[https://github.com/chalaev/lisp-goodies/blob/master/packaged/version.el][version.el]]" >> $@
	-@chgrp tmp $@

generated/from/%.org: %.org generated/from/
	@echo "\nNow emacs is probably waiting for your responce..."
	emacsclient -e "(progn (require 'version) (printangle \"$<\"))" | sed 's/"//g' > $@
	-@chgrp tmp $@ `cat $@`
	-@chmod a-x `cat $@`

README.md: README.org
	emacsclient -e '(progn (find-file "README.org") (org-md-export-to-markdown))'
	sed -i "s/\.md)/.org)/g"  $@
	-@chgrp tmp $@
	-@chmod a-x $@

clean:
	-rm -r generated packaged version.org

.PHONY: clean

%/:
	[ -d $@ ] || mkdir -p $@
