import os
import json
import csv

def aggregate_dataset_shapes(json_dir, output_csv):
    data = []

    for filename in os.listdir(json_dir):
        if filename.endswith(".json"):
            filepath = os.path.join(json_dir, filename)
            try:
                with open(filepath, 'r') as f:
                    content = json.load(f)

                orig_shape = content.get("orig", [None, None])
                preprocessed_shape = content.get("preprocessed", [None, None])

                row = {
                    "Dataset": filename.split('.')[0],
                    "orig_rows": orig_shape[0],
                    "orig_cols": orig_shape[1],
                    "preprocessed_rows": preprocessed_shape[0],
                    "preprocessed_cols": preprocessed_shape[1]
                }
                data.append(row)

            except Exception as e:
                print(f"Error processing {filename}: {e}")

    # Write to CSV
    with open(output_csv, "w", newline='') as csvfile:
        fieldnames = ["Dataset", "orig_rows", "orig_cols", "preprocessed_rows", "preprocessed_cols"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)

    print(f"Saved CSV summary to: {output_csv}")

# Example usage:
json_dir = "dataset_analysis"
output_csv = "aggregated_dataset_info.csv"
aggregate_dataset_shapes(json_dir, output_csv)