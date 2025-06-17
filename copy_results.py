import shutil
import os

# Paths
old_results_base = 'cross_val_results_50'
new_results_base = 'cross_val_results_add'  # Structure: new_results/algorithm1/fold*.mat

# List of updated algorithms
algorithms_to_replace = ['MCFS', 'NDFS', 'RUFS', 'UDFS']

# Loop through all dataset directories
for dataset_name in os.listdir(old_results_base):
    dataset_path = os.path.join(old_results_base, dataset_name)
    
    if not os.path.isdir(dataset_path):
        continue

    for algorithm in algorithms_to_replace:
        old_algo_path = os.path.join(dataset_path, algorithm)
        new_algo_path = os.path.join(new_results_base, dataset_name, algorithm)
        print("OLD PATH")
        print(old_algo_path)
        print("NEW PATH")
        print(new_algo_path)
        
        if not os.path.exists(new_algo_path):
            print(f"Warning: Missing new results for {dataset_name}/{algorithm}, skipping.")
            continue

        # Replace each fold file
        for file_name in os.listdir(new_algo_path):
            if file_name.endswith('.mat'):
                src_file = os.path.join(new_algo_path, file_name)
                dst_file = os.path.join(old_algo_path, file_name)

                shutil.copy2(src_file, dst_file)
                print(f"Replaced: {dst_file}")