PNG=$(patsubst %.puml,%.png,$(wildcard *.puml))
BIB=$(wildcard *.bib)
DEPS=$(patsubst %.tex,%.bbl,$(wildcard *.tex))
PDF=$(patsubst %.tex,%.pdf,$(wildcard *.tex))

export TEXMFCNF := "texmf:"

test:
	@echo "Testing TEXMFCNF list"
	kpsewhich --all texmf.cnf

all: $(PNG) $(PDF) $(DEPS)
	@echo "BUILDING all DEPS=$(DEPS)"

%.png: %.puml
	@echo "BUILDING png $@ $<"
	plantuml $^

%.bbl: $(BIB)
	@echo "BUILDING bbl $@ $<"
	pdflatex $(patsubst %.bbl,%.tex,$@)
	bibtex $(basename $@)
	pdflatex $(patsubst %.bbl,%.tex,$@)
	rm $(patsubst %.bbl,%.pdf,$@)

%.pdf: %.tex $(DEPS)
	@echo "BUILDING pdf $@ $<"
	pdflatex $<

clean:
	rm *.pdf *.log *.aux *.dvi *.bbl *.fls *.blg *.fdb_latexmk *.spl *.gz *.lof *.lot *.out contents/*.pdf contents/*.aux contents/*.fls contents/*.log contents/*.fdb_latexmk

