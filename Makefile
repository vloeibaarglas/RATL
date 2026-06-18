.PHONY: spec test examples clean

spec: specs/RATL_SPEC.pdf

specs/RATL_SPEC.md: src/ratl_def.tsv scripts/generate_spec.py
	python3 scripts/generate_spec.py > specs/RATL_SPEC.md

specs/RATL_SPEC.pdf: specs/RATL_SPEC.md
	quarto render specs/RATL_SPEC.md --to pdf

test:
	Rscript tests/test_runner.R

examples:
	@for f in examples/*.ratl; do \
		timeout 10 Rscript src/RATL.R "$$(cat $$f)" < /dev/null > /dev/null 2>&1 || echo "FAIL: $$f"; \
	done
	@echo "Done"

clean:
	rm -f specs/RATL_SPEC.pdf specs/RATL_SPEC.md
