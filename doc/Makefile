
GAP=gap4ws

gapdoc:
	@echo 'MakeGAPDocDoc( "./", "nqnew", [], "nq" );;' | $(GAP) -q -T

clean:
	@rm -f nqnew.aux nqnew.bbl nqnew.blg nqnew.idx nqnew.ilg nqnew.ind\
	   nqnew.log nqnew.pnr nqnew.tex nqnew.toc nqnew.brf
	@rm -f manual.dvi manual.html manual.pdf manual.ps manual.six
	@rm -f chap*.html chap*.txt *~

spotless: clean
