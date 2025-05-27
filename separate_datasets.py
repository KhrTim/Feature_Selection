import pandas as pd
import os
import shutil
from pathlib import Path
import numpy as np
import sys

def distribute_by_column_count(
    df: pd.DataFrame,
    dataset_col: str,
    source_dir: str,
    output_dir: str,
    num_machines: int,
    machine_index: int
):
    # Sort by column count (descending) for greedy balancing
    df = df.sort_values("preprocessed_cols", ascending=False).reset_index(drop=True)

    # Initialize machine buckets
    machines = [[] for _ in range(num_machines)]
    machine_col_sums = [0] * num_machines

    # Greedy allocation
    for _, row in df.iterrows():
        dataset_name = row[dataset_col]
        num_cols = row["preprocessed_cols"]

        # Assign to the machine with the least total cols so far
        min_machine = np.argmin(machine_col_sums)
        machines[min_machine].append(dataset_name)
        machine_col_sums[min_machine] += num_cols

    # Only process the specified machine
    machine_files = machines[machine_index]
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    for fname in machine_files:
        src = Path(source_dir) / fname
        dst = output_path / fname

        try:
            if dst.exists() or dst.is_symlink():
                dst.unlink()
            os.symlink(src.resolve(), dst)
            print(f"Symlinked: {src} -> {dst}")
        except Exception as e:
            print(f"Failed to symlink {src}: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <machine_index>")
        sys.exit(1)

    machine_index = int(sys.argv[1])
    num_machines = 3  # Adjust as needed

    df = pd.read_csv("aggregated_dataset_info.csv")  # Must contain 'Dataset' and 'preprocessed_cols'

    distribute_by_column_count(
        df,
        dataset_col="Dataset",
        source_dir="all_datasets",
        output_dir="data",  # Destination for symlinks
        num_machines=num_machines,
        machine_index=machine_index
    )