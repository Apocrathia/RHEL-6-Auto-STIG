#!/bin/bash

# this is probably a lost cause, because the CSV export
# from the DISA STIG viewer strips a lot of formatting.

nextfield () {
  case "$line" in
    \"*)
      value="${line%%\",*}\""
      line="${line#*\",}"
      ;;
    *)
      value="${line%%,*}"
      line="${line#*,}"
      ;;
  esac
}

comment () {
	fold -sw 55 <<< "$1" | nl -bn -s"# " -w 1
}

# loop through the file
while read line; do
	# get all of the content
	nextfield; vulnid="$value"
	nextfield; ruleid="$value"
	nextfield; stigid="$value"
	nextfield; title="$value"
	nextfield; discussion="$value"
	nextfield; check="$value"
	nextfield; fix="$value"

	# Format the content

	echo "########################################################"
	echo "# Vulnerability ID: $vulnid"
	echo "# Rule ID: $ruleid"
	echo "# STIG ID: $stigid"
	echo "#"
	echo "# Rule:"
	comment "$title"
	echo "#"
	echo "# Discussion:"
	comment "$discussion"
	echo "# Check:"
	comment "$check"
	echo "# Fix:"
	comment "$fix"
	echo "########################################################"
	echo "# Start Check"
	echo
	echo "# Start Remediation"
	echo
	echo "########################################################"
	echo
done < STIG.csv
