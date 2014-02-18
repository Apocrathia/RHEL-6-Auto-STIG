#!/bin/bash

# loop through the file
while read line; do
	# get all of the content
	vulnid=`echo $line | awk '{print $1}'`
	ruleid=`echo $line | cut -d',' -f2`
	stigid=`echo $line | cut -d',' -f3`
	title=`echo $line | cut -d',' -f4`
	discussion=`echo $line | cut -d',' -f5`
	check=`echo $line | cut -d',' -f6`
	fix=`echo $line | cut -d',' -f7`

	# Format the content

	echo "########################################################"
	echo "# Vulnerability ID: $vulnid"
	echo "# Rule ID: $ruleid"
	echo "# STIG ID: $stigid"
	echo "#"
	echo "# Rule: $title"
	echo "#"
	echo "# Discussion:"
	echo "# $discussion"
	echo "# Check:"
	echo "# $check"
	echo "# Fix:"
	echo "# $fix"
	echo "########################################################"
	echo "# Start Check"
	echo
	echo "# Start Remediation"
	echo
	echo "########################################################"
done < STIG.csv
