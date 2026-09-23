from datasets import load_dataset

dataset = load_dataset(
    "wikimedia/wikipedia",
    "20231101.en",
    split="train",
    streaming=True,
)

for i, example in enumerate(dataset):
    print(example["title"])
    if i >= 4:
        break