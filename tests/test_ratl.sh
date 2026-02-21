#!/bin/bash
# RATL Test Runner Wrapper

# Get to the project root
cd "$(dirname "$0")/.."

echo "Running legacy example execution check..."
for f in examples/*.ratl; do
  echo "Checking $f..."
  if [[ "$f" == *"01_aplusb.ratl" ]]; then
    echo -e "5\n10" | ./src/RATL.R "$(cat $f)" > /dev/null
  else
    ./src/RATL.R "$(cat $f)" > /dev/null
  fi
  if [ $? -ne 0 ]; then
    echo "FAILED: $f"
    exit 1
  fi
done

echo ""
echo "Running Unit Tests with Output Verification..."
./tests/test_runner.R
