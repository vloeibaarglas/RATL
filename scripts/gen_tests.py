#!/usr/bin/env python3
"""Generate tests/test_all_symbols.R from src/ratl_def.tsv + src/ratl_tests.tsv"""

import sys
import re
from collections import OrderedDict


def load_def(path):
    symbols = []
    with open(path) as f:
        header = f.readline()
        for line in f:
            parts = line.rstrip('\n').split('\t')
            if len(parts) >= 6:
                unsafe = parts[6].strip() == '1' if len(parts) > 6 else False
                symbols.append({
                    'src': parts[0],
                    'r_code': parts[1],
                    'n_in': int(parts[2]),
                    'n_out': int(parts[3]),
                    'desc': parts[4],
                    'category': parts[5],
                    'unsafe': unsafe,
                })
    return symbols


def load_tests(path):
    tests = {}
    with open(path) as f:
        header = f.readline()
        for line in f:
            parts = line.rstrip('\n').split('\t')
            if len(parts) >= 2:
                tests[parts[0]] = {
                    'test_input': parts[1],
                    'expected': parts[2] if len(parts) > 2 else '',
                }
    return tests


def escape_test_name(s):
    return re.sub(r'[^A-Za-z0-9_]', '_', s)


def generate_test_r(symbols, tests):
    lines = []
    lines.append('#!/usr/bin/env Rscript')
    lines.append('# Auto-generated unit tests from src/ratl_def.tsv + src/ratl_tests.tsv')
    lines.append('# Do not edit manually — run: python3 scripts/gen_tests.py')
    lines.append('')
    lines.append('source("src/ratl_lib.R")')
    lines.append('source("src/ratl_stack.R")')
    lines.append('source("src/ratl_dispatch.R")')
    lines.append('source("src/ratl_parse.R")')
    lines.append('source("src/ratl_eval.R")')
    lines.append('dispatch_env <- build_dispatch("src/ratl_def.tsv")')
    lines.append('')
    lines.append('run_ratl <- function(code) {')
    lines.append('  tokens <- ratl_parse(code, dispatch_env)')
    lines.append('  ctx <- new.env(parent = emptyenv())')
    lines.append('  ctx$stack <- make_stack()')
    lines.append('  ctx$dispatch <- dispatch_env')
    lines.append('  ctx$clipboards <- new.env(parent = emptyenv())')
    lines.append('  ctx$stdin <- file("/dev/null", "r")')
    lines.append('  ctx$in_loop <- FALSE')
    lines.append('  tryCatch({')
    lines.append('    ratl_eval(tokens, ctx)')
    lines.append('    close(ctx$stdin)')
    lines.append('    s <- ctx$stack')
    lines.append('    if (stack_length(s) == 1) paste(stack_peek(s), collapse=" ")')
    lines.append('    else if (stack_length(s) > 1) paste(sapply(stack_to_list(s), function(x) paste(x, collapse=" ")), collapse=" ")')
    lines.append('    else ""')
    lines.append('  }, error = function(e) { tryCatch(close(ctx$stdin), error=function(e2) NULL); paste("ERROR:", e$message) })')
    lines.append('}')
    lines.append('')
    lines.append('escape_test_name <- function(s) {')
    lines.append('  gsub("[^A-Za-z0-9_]", "_", s)')
    lines.append('}')
    lines.append('')
    lines.append('set.seed(42)')
    lines.append('passed <- 0')
    lines.append('failed <- 0')
    lines.append('skipped <- 0')
    lines.append('failures <- character()')
    lines.append('')

    test_count = sum(1 for s in symbols if s['src'] in tests and tests[s['src']]['test_input'])
    lines.append(f'cat(sprintf("Testing {test_count} symbols (unit tests)\\n"))')
    lines.append('cat("============================\\n")')
    lines.append('')

    random_symbols = {'rnorm','rbinom','rpois','rexp','rbeta','rcauchy',
                      'rchisq','rgeom','rhyper','rlnorm','rlogis',
                      'rnbinom','runif','rweibull','rf','rt'}

    for s in symbols:
        src = s['src']
        desc = s['desc']
        cat = s['category']
        func_name = escape_test_name(f"{src}_{desc}")

        t = tests.get(src, {})
        test_input = t.get('test_input', '')
        expected = t.get('expected', '')

        if not test_input:
            lines.append(f'# SKIP {src} ({desc}) — no test defined')
            lines.append(f'skipped <- skipped + 1')
            lines.append('')
            continue

        lines.append(f'# {cat}: {src} — {desc}')
        lines.append(f'test_{func_name} <- function() {{')
        if s['n_in'] == 0 or any(s['r_code'].startswith(x) for x in random_symbols):
            lines.append(f'  set.seed(42)')
        lines.append(f'  r <- run_ratl("{test_input}")')
        if expected:
            expected_escaped = expected.replace('\\', '\\\\').replace('"', '\\"')
            lines.append(f'  if (grepl("Error:", r)) {{ cat("FAIL [{src}] {desc}: ", r, "\\n"); return(FALSE) }}')
            lines.append(f'  if (r != "{expected_escaped}") {{')
            lines.append(f'    cat("FAIL [{src}] {desc}: expected [{expected_escaped}], got [", r, "]\\n")')
            lines.append(f'    return(FALSE)')
            lines.append(f'  }}')
            lines.append(f'  return(TRUE)')
        else:
            lines.append(f'  if (grepl("Error:", r)) {{ cat("FAIL [{src}] {desc}: ", r, "\\n"); return(FALSE) }}')
            lines.append(f'  return(TRUE)')
        lines.append(f'}}')
        lines.append('')

    lines.append('all_tests <- list(')
    first = True
    for s in symbols:
        t = tests.get(s['src'], {})
        if not t.get('test_input'):
            continue
        func_name = escape_test_name(f"{s['src']}_{s['desc']}")
        if not first:
            lines.append(',')
        lines.append(f'  list(name = "{s["src"]} {s["desc"]}", fn = test_{func_name})')
        first = False
    lines.append(')')
    lines.append('')
    lines.append('for (t in all_tests) {')
    lines.append('  cat(sprintf("%-30s ... ", t$name))')
    lines.append('  if (t$fn()) { cat("PASS\\n"); passed <- passed + 1 }')
    lines.append('  else { failed <- failed + 1; failures <- c(failures, t$name) }')
    lines.append('}')
    lines.append('')
    lines.append('cat("============================\\n")')
    lines.append('cat(sprintf("Tests run: %d | Passed: %d | Failed: %d | Skipped: %d\\n",')
    lines.append('            passed + failed, passed, failed, skipped))')
    lines.append('if (failed > 0) {')
    lines.append('  cat("\\nFailed tests:\\n")')
    lines.append('  for (f in failures) cat(sprintf("  - %s\\n", f))')
    lines.append('  quit(status = 1)')
    lines.append('}')

    return '\n'.join(lines)


if __name__ == '__main__':
    def_path = sys.argv[1] if len(sys.argv) > 1 else 'src/ratl_def.tsv'
    test_path = sys.argv[2] if len(sys.argv) > 2 else 'src/ratl_tests.tsv'
    out_path = sys.argv[3] if len(sys.argv) > 3 else 'tests/test_all_symbols.R'

    symbols = load_def(def_path)
    tests = load_tests(test_path)
    r_code = generate_test_r(symbols, tests)

    with open(out_path, 'w') as f:
        f.write(r_code)

    test_count = len([s for s in symbols if s['src'] in tests and tests[s['src']]['test_input']])
    skip_count = len([s for s in symbols if s['src'] not in tests or not tests[s['src']]['test_input']])
    print(f"Generated {out_path} with {test_count} tests ({skip_count} skipped)")
