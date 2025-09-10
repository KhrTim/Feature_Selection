# Feature Selection Framework

A comprehensive MATLAB-based framework for evaluating and comparing unsupervised feature selection algorithms on various datasets.

## Overview

This repository implements a feature selection benchmarking system that supports 25+ state-of-the-art unsupervised feature selection algorithms. It provides a unified interface for algorithm evaluation, cross-validation experiments, and performance analysis across multiple datasets.

## Key Features

- **Comprehensive Algorithm Support**: Implements 25+ feature selection algorithms including MCFS, FSDK, LRPFS, SLNMF, GRSSLFS, RAFG, FMIUFS, and custom proposed methods
- **Cross-Validation Framework**: 10-fold cross-validation with stratified sampling for robust evaluation
- **Multiple Performance Metrics**: Gini impurity, uniqueness, entropy ratio, NMI (Normalized Mutual Information), and classification accuracy
- **Flexible Data Handling**: Supports both categorical and continuous features with automatic preprocessing
- **Result Aggregation**: JSON-based result storage and analysis tools

## Project Structure

```
├── algs/                   # Feature selection algorithms
│   ├── MCFS/              # Multi-Cluster Feature Selection
│   ├── FSDK/              # Feature Selection with Dynamic K-means
│   ├── LRPFS/             # Low-Rank Preserving Feature Selection
│   ├── SLNMF/             # Structured Low-rank Non-negative Matrix Factorization
│   ├── proposed*.m        # Custom proposed algorithms
│   └── ...                # 20+ other algorithms
├── experiment.m           # Main experiment runner
├── apply_fs.m            # Feature selection application script
├── ufs_alg.m             # Unified algorithm interface
├── exp_set.json          # Algorithm configuration
├── aggregated_results.json # Performance results
└── *.mat                 # Data files and results
```

## Usage

### Running Experiments

1. **Configure algorithms**: Edit `exp_set.json` to specify which algorithms to run and their parameters
2. **Prepare data**: Place dataset files in `.mat` format (expected in `data/` directory)
3. **Run experiments**:
   ```matlab
   experiment
   ```

### Dataset Format

Datasets should be in MATLAB `.mat` format with variables:
- `fea`: Feature matrix (samples × features)
- `gnd`: Ground truth labels
- `cate_flag`: Boolean indicating categorical (1) or continuous (0) features

### Algorithm Configuration

The `exp_set.json` file defines:
```json
{
    "param_struct": [
        {
            "alg": "MCFS",
            "param": 0
        },
        {
            "alg": "LRPFS", 
            "param": [1, 1, 5]
        }
    ],
    "max_fea": 300,
    "clus_iter": 50
}
```

## Implemented Algorithms

### Classical Methods
- **MCFS**: Multi-Cluster Feature Selection
- **LS**: Laplacian Score
- **MAX_VAR**: Maximum Variance

### Matrix Factorization Based
- **SLNMF**: Structured Low-rank Non-negative Matrix Factorization
- **LRPFS**: Low-Rank Preserving Feature Selection
- **FSDK**: Feature Selection with Dynamic K-means

### Graph-Based Methods
- **GRSSLFS**: Graph Regularized Self-Supervised Learning Feature Selection
- **NDFS**: Nonnegative Discriminative Feature Selection
- **UDFS**: Unsupervised Discriminative Feature Selection

### Clustering-Oriented
- **RAFG**: Robust Auto-weighted Feature Generation
- **MGAGR**: Multi-Graph Adaptive Graph Regularization
- **U2FS**: Unified Unsupervised Feature Selection

### Advanced Methods
- **EGCFS**: Enhanced Graph-based Clustering Feature Selection
- **VCSDFS**: View-Consistent Structured Deep Feature Selection
- **JMVFG**: Joint Multi-View Feature Generation

### Custom Proposed Methods
- **PROP**: Entropy-based feature selection
- **PROPQ**: Quadratic variant
- **PROPS**: Structured variant

## Performance Metrics

- **Gini Impurity**: Measures feature discriminative power
- **Uniqueness**: Evaluates feature diversity
- **Entropy Ratio**: Information-theoretic measure
- **NMI**: Normalized Mutual Information with ground truth
- **Classification Accuracy**: Naive Bayes and Decision Tree performance
- **Runtime**: Algorithm execution time

## Results and Analysis

Results are stored in JSON format with statistical summaries:
- Mean and standard deviation across cross-validation folds
- Per-dataset and per-algorithm performance breakdowns
- Aggregated rankings and comparisons

## Dependencies

- MATLAB R2016b or later
- Statistics and Machine Learning Toolbox
- Optional: Parallel Computing Toolbox for faster execution

## Citation

If you use this framework in your research, please consider citing the relevant algorithm papers implemented in this repository.