.PHONY: spec test gen-tests examples clean

spec: specs/RATL_SPEC.html

specs/RATL_SPEC.md: src/ratl_def.tsv scripts/gen_spec.py
	python3 scripts/gen_spec.py > specs/RATL_SPEC.md

specs/RATL_SPEC.html: specs/RATL_SPEC.md
	pandoc $< -s --embed-resources --metadata title="RATL Specification" -o $@

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
	rm -f specs/RATL_SPEC.html specs/RATL_SPEC.md
