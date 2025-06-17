import os
import re
from datetime import datetime

# Target root directory
base_path = 'cross_val_results_50'  # same structure: dataset/algorithm/files

# Regex to extract timestamp from filenames
timestamp_pattern = re.compile(r'data_file_(\d{8})_(\d{6})_.*\.mat')

# Go through each dataset and algorithm directory
for dataset in os.listdir(base_path):
    dataset_path = os.path.join(base_path, dataset)
    if not os.path.isdir(dataset_path):
        continue

    for algorithm in os.listdir(dataset_path):
        algo_path = os.path.join(dataset_path, algorithm)
        if not os.path.isdir(algo_path):
            continue

        mat_files = [f for f in os.listdir(algo_path) if f.endswith('.mat')]

        file_timestamps = []

        for f in mat_files:
            match = timestamp_pattern.match(f)
            if match:
                date_str, time_str = match.groups()
                try:
                    dt = datetime.strptime(f"{date_str}_{time_str}", "%Y%m%d_%H%M%S")
                    file_timestamps.append((f, dt))
                except ValueError:
                    print(f"Warning: Couldn't parse timestamp in {f}")
            else:
                print(f"Skipping non-matching file: {f}")

        # Sort by timestamp descending (newest first)
        file_timestamps.sort(key=lambda x: x[1], reverse=True)

        # Files to delete: all but the top 10
        to_delete = file_timestamps[10:]

        for filename, _ in to_delete:
            file_path = os.path.join(algo_path, filename)
            os.remove(file_path)
            print(f"Deleted: {file_path}")
