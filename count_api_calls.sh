#!/bin/bash

# Check if at least one log file is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 log_file1.log [log_file2.log ...]"
  exit 1
fi

# Temporary file to store combined results
TEMP_FILE="combined_results.txt"

# Clear the temporary file if it exists
> $TEMP_FILE

# Iterate over each log file provided as a positional parameter
for LOG_FILE in "$@"; do
  # Check if the file exists
  if [ ! -f "$LOG_FILE" ]; then
    echo "File not found: $LOG_FILE"
    continue
  fi

  # Extract lines with command=, get the hour from the timestamp, and append to the temporary file
  grep 'command=' "$LOG_FILE" | awk '{print substr($1 " " $2, 1, 13)}' >> $TEMP_FILE
done

# Sort the combined results and count occurrences per hour
sort $TEMP_FILE | uniq -c > hourly_counts.txt

# Display the results
cat hourly_counts.txt

# Clean up
rm $TEMP_FILE
rm hourly_counts.txt
