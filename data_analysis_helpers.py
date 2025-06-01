import pandas as pd
import numpy as np


def to_latex_table(original_df: pd.DataFrame, first_col=None, choose_max=True) -> str:
    """
    Converts the formatted DataFrame to a LaTeX table with bolded best values,
    sorted by dataset name, and includes average rankings after midrule.
    """
    # Wide mean and std
    mean_wide = original_df.pivot(index='Dataset', columns='Algorithm', values='Mean')
    std_wide = original_df.pivot(index='Dataset', columns='Algorithm', values='Std')

    # Sort datasets alphabetically
    mean_wide.index = [i.capitalize() for i in mean_wide.index]
    std_wide.index = mean_wide.index  # make sure std_wide uses the same index

    # Now sort alphabetically
    mean_wide = mean_wide.sort_index()
    std_wide = std_wide.sort_index()

    # Reorder columns to make `first_col` first if provided
    if first_col and first_col in mean_wide.columns:
        cols = [first_col] + [col for col in mean_wide.columns if col != first_col]
        mean_wide = mean_wide[cols]
        std_wide = std_wide[cols]

    # Determine best algorithms
    if choose_max:
        best_algos = mean_wide.idxmax(axis=1)
    else:
        best_algos = mean_wide.idxmin(axis=1)


    def bold_if_best(dataset, algo):
        mean = mean_wide.loc[dataset, algo]
        std = std_wide.loc[dataset, algo]
        formatted = f"{mean:0.4f} $\\pm$ {std:0.4f}" 
        if best_algos[dataset] == algo:
            return f"\\textbf{{{formatted}}}"
        else:
            return formatted

    # Build LaTeX-formatted DataFrame
    latex_df = pd.DataFrame(index=mean_wide.index, columns=mean_wide.columns)
    for dataset in mean_wide.index:
        for algo in mean_wide.columns:
            latex_df.loc[dataset, algo] = bold_if_best(dataset, algo)

    # Compute average rankings
    if choose_max:
        ranks = mean_wide.rank(axis=1, method='average', ascending=False)
    else:
        ranks = mean_wide.rank(axis=1, method='average', ascending=True)

    avg_ranks = ranks.mean()
    best_rank = avg_ranks.min()

    avg_rank_row = {}
    for algo in mean_wide.columns:
        rank_str = f"{avg_ranks[algo]:.2f}"
        if avg_ranks[algo] == best_rank:
            avg_rank_row[algo] = f"\\textbf{{{rank_str}}}"
        else:
            avg_rank_row[algo] = rank_str

    # Add average ranking row with \midrule
    latex_df.loc["\\midrule\nAverage Rank"] = avg_rank_row
    
    # Escape underscores
    latex_df.index = [
    i.replace('_', '\\_') if not i.startswith('\\midrule') else i
    for i in latex_df.index
]

    latex_df.columns = [i.replace('_', '\\_') for i in latex_df.columns]

    return latex_df.to_latex(
        escape=False,
        column_format='l' + 'c' * latex_df.shape[1],
    )



def prepare_measure_df(df, measure_name, selected_algorithms):
    df_filtered = df[df['Algorithm'].isin(selected_algorithms)].copy()
    
    # Capitalize and escape underscores in dataset names
    df_filtered['Dataset'] = df_filtered['Dataset'].str.replace('_', r'\_', regex=False).str.title()

    df_filtered = df_filtered.sort_values(['Dataset', 'Algorithm'])
    df_filtered = df_filtered[['Dataset', 'Algorithm', 'Mean']]
    df_filtered['Mean'] = df_filtered['Mean'].round(2)

    # Pivot to wide format
    df_pivot = df_filtered.pivot(index='Dataset', columns='Algorithm', values='Mean')

    # Sort rows alphabetically by dataset name
    df_pivot = df_pivot.sort_index()

    # Bold best values
    def bold_best(row):
        max_val = row.max()
        return row.apply(lambda x: f"\\textbf{{{x:.2f}}}" if x == max_val else f"{x:.2f}")

    df_bold = df_pivot.apply(bold_best, axis=1)
    df_bold.columns = [f"{measure_name} {col}" for col in df_bold.columns]

    df_rank = df_pivot.rank(axis=1, ascending=False)

    return df_bold, df_rank

def create_latex_table(measure_dfs, measure_names, selected_algorithms):
    all_tables = []
    all_ranks = []

    for df, name in zip(measure_dfs, measure_names):
        formatted, ranks = prepare_measure_df(df, name, selected_algorithms)
        all_tables.append(formatted)
        all_ranks.append(ranks)

    # Combine both metrics side-by-side
    result = pd.concat(all_tables, axis=1)
    
    # Compute average ranks
    total_ranks = pd.concat(all_ranks, axis=1)

    # Extract algorithm names from column names like "Entropy Ratio ORIG"
    alg_rank_map = {col: col.split()[-1] for col in total_ranks.columns}
    total_ranks.columns = pd.MultiIndex.from_tuples([(alg_rank_map[col], col) for col in total_ranks.columns])

    # Now group by algorithm name (level=0)
    avg_ranks = total_ranks.groupby(level=0, axis=1).mean().mean().round(2)
    
    avg_row = {col: "" for col in result.columns}
    for alg in selected_algorithms:
        for name in measure_names:
            col = f"{name} {alg}"
            if col in result.columns:
                avg_row[col] = f"{avg_ranks[alg]:.2f}"
    avg_row["Dataset"] = "Avg. Rank"

    result.reset_index(inplace=True)
    result = pd.concat([result, pd.DataFrame([avg_row])], ignore_index=True)

    # Reorder columns to make sure 'Dataset' comes first
    cols = result.columns.tolist()
    cols = ['Dataset'] + [c for c in cols if c != 'Dataset']
    result = result[cols]

    return result

def df_to_latex(df, caption="Comparison table", label="tab:comparison"):

    # Separate data and avg row
    df_main = df.iloc[:-1].copy()
    df_avg = df.iloc[-1:].copy()

    # Prepare main LaTeX table (without Avg. Rank)
    latex_main = df_main.to_latex(index=False, escape=False, column_format="l" + "c" * (df.shape[1] - 1))

    # Bold the minimum average rank values (excluding first column)
    avg_values = df_avg.iloc[0].tolist()
    header = df_avg.columns.tolist()
    
    min_val = float('inf')
    numeric_indices = []

    for i, val in enumerate(avg_values[1:], start=1):
        try:
            fval = float(val)
            numeric_indices.append((i, fval))
            if fval < min_val:
                min_val = fval
        except ValueError:
            continue

    # Apply bold formatting to min values
    for i, fval in numeric_indices:
        if fval == min_val:
            avg_values[i] = f"\\textbf{{{fval:.2f}}}"
        else:
            avg_values[i] = f"{fval:.2f}"

    # First column (Dataset) value
    avg_values[0] = df_avg.iloc[0, 0]

    # Manually format LaTeX row
    avg_row_latex = " & ".join(avg_values) + r" \\"

    # Insert after \midrule
    lines = latex_main.splitlines()
    insert_idx = len(lines) - 2  # fallback


    lines.insert(insert_idx, avg_row_latex)
    lines.insert(insert_idx, '\\midrule')

    latex_table = "\n".join(lines)

    return f"""\\begin{{table}}[htbp]
\\centering
\\caption{{{caption}}}
\\label{{{label}}}
{latex_table}
\\end{{table}}"""

# ✅ Example usage:
# df = pd.read_csv("your_data.csv")  # Assuming you loaded the data
# wide_df = reshape_df(df)
# avg_ranks = compute_average_rankings(df)
# latex_code = to_latex_table(wide_df, df)