from datasets import load_dataset

dataset = load_dataset("stanfordnlp/imdb", split="train")
small = dataset.select(range(1000))
small.to_csv("imdb_1000.csv")
small.to_parquet("imdb_1000.parquet")
print("wrote 1000 rows")