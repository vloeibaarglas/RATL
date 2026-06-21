.PHONY: spec test gen-tests examples clean

spec: docs/RATL_SPEC.html

docs/RATL_SPEC.qmd: src/ratl_def.tsv scripts/gen_spec.py
	python3 scripts/gen_spec.py > docs/RATL_SPEC.qmd

docs/RATL_SPEC.html: docs/RATL_SPEC.qmd docs/theme.css docs/datatables-init.html docs/_quarto.yml
	cd docs && quarto render RATL_SPEC.qmd

gen-tests: tests/test_all_symbols.R

tests/test_all_symbols.R: src/ratl_def.tsv scripts/gen_tests.py
	python3 scripts/gen_tests.py

test: gen-tests
	Rscript tests/test_all_symbols.R
	Rscript tests/test_runner.R

examples:
	@for f in examples/*.ratl; do \
		timeout 10 Rscript src/RATL.R "$$(cat $$f)" < /dev/null > /dev/null 2>&1 || echo "FAIL: $$f"; \
	done
	@echo "Done"

clean:
	rm -f docs/RATL_SPEC.html docs/RATL_SPEC.qmd
