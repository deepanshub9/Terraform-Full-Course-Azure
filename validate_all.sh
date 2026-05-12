#!/bin/bash

# Terraform Azure Course - Validation Script
# This script validates all updated configurations

echo "======================================"
echo "Terraform Azure Course Update Validator"
echo "======================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Count variables
TOTAL_DAYS=0
PASSED=0
FAILED=0

# Array of all days
DAYS=(03 04 05 06 07 08 09 10 11-12 13 14 15 17 18 19 20 21 22 23 24 26 27 28)

echo "Validating all Terraform configurations..."
echo ""

for day in "${DAYS[@]}"; do
    TOTAL_DAYS=$((TOTAL_DAYS + 1))
    
    if [ "$day" = "11-12" ] || [ "$day" = "27" ] || [ "$day" = "28" ]; then
        if [ "$day" = "11-12" ]; then
            DIR="lessons/day11-12"
        elif [ "$day" = "27" ]; then
            DIR="lessons/day27/infra"
        else
            DIR="lessons/day28/dev"
        fi
    else
        DIR="lessons/day$day"
    fi
    
    if [ -d "$DIR" ]; then
        cd "$DIR" 2>/dev/null || continue
        
        # Run terraform validate
        if terraform validate > /dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} Day $day: PASSED"
            PASSED=$((PASSED + 1))
        else
            echo -e "${RED}✗${NC} Day $day: FAILED"
            FAILED=$((FAILED + 1))
        fi
        
        cd - > /dev/null
    else
        echo -e "${YELLOW}⊙${NC} Day $day: SKIPPED (directory not found)"
    fi
done

echo ""
echo "======================================"
echo "Validation Summary"
echo "======================================"
echo "Total Days Checked: $TOTAL_DAYS"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All configurations are valid!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some configurations failed validation${NC}"
    exit 1
fi
