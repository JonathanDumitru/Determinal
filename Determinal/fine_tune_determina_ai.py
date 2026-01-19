#!/usr/bin/env python3
"""
DeterminaAI Fine-Tuning Script
Fine-tunes Phi-2 on terminal/coding dataset
"""

import json
import torch
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    TrainingArguments,
    Trainer,
    DataCollatorForLanguageModeling
)
from datasets import Dataset
from typing import Dict, List

class DeterminaAITrainer:
    def __init__(self, base_model: str = "microsoft/phi-2"):
        self.base_model = base_model
        self.model = None
        self.tokenizer = None
        
    def load_model(self):
        """Load base model and tokenizer"""
        print(f"📦 Loading {self.base_model}...")
        
        self.tokenizer = AutoTokenizer.from_pretrained(self.base_model)
        self.tokenizer.pad_token = self.tokenizer.eos_token
        
        self.model = AutoModelForCausalLM.from_pretrained(
            self.base_model,
            torch_dtype=torch.float16,
            device_map="auto",
            trust_remote_code=True
        )
        
        print("✅ Model loaded successfully")
        
    def prepare_dataset(self, data_file: str) -> Dataset:
        """Prepare training dataset"""
        print(f"📊 Loading training data from {data_file}...")
        
        # Load JSONL data
        examples = []
        with open(data_file, 'r') as f:
            for line in f:
                examples.append(json.loads(line))
        
        # Format for training
        formatted_examples = []
        for ex in examples:
            text = self.format_example(ex)
            formatted_examples.append({"text": text})
        
        dataset = Dataset.from_list(formatted_examples)
        print(f"✅ Loaded {len(dataset)} training examples")
        
        return dataset
    
    def format_example(self, example: Dict) -> str:
        """Format training example with DeterminaAI branding"""
        return f"""Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
{example['instruction']}

### Response (DeterminaAI):
{example['output']}<|endoftext|>"""
    
    def tokenize_dataset(self, dataset: Dataset) -> Dataset:
        """Tokenize dataset"""
        print("🔤 Tokenizing dataset...")
        
        def tokenize_function(examples):
            return self.tokenizer(
                examples["text"],
                truncation=True,
                max_length=512,
                padding="max_length"
            )
        
        tokenized = dataset.map(
            tokenize_function,
            batched=True,
            remove_columns=dataset.column_names
        )
        
        print("✅ Dataset tokenized")
        return tokenized
    
    def train(self, dataset: Dataset, output_dir: str = "./determina-ai"):
        """Fine-tune the model"""
        print("🚀 Starting fine-tuning...")
        
        training_args = TrainingArguments(
            output_dir=output_dir,
            num_train_epochs=3,
            per_device_train_batch_size=2,
            gradient_accumulation_steps=8,
            learning_rate=2e-5,
            warmup_steps=100,
            logging_steps=10,
            save_steps=500,
            save_total_limit=2,
            fp16=True,
            report_to="none",
            push_to_hub=False,
        )
        
        trainer = Trainer(
            model=self.model,
            args=training_args,
            train_dataset=dataset,
            data_collator=DataCollatorForLanguageModeling(
                tokenizer=self.tokenizer,
                mlm=False
            ),
        )
        
        trainer.train()
        print("✅ Training complete!")
        
    def save_model(self, output_path: str = "./determina-ai-final"):
        """Save fine-tuned model"""
        print(f"💾 Saving model to {output_path}...")
        
        self.model.save_pretrained(output_path)
        self.tokenizer.save_pretrained(output_path)
        
        print("✅ Model saved successfully")
        print(f"\n🎉 DeterminaAI is ready!")
        print(f"📁 Model location: {output_path}")
        print("\nNext steps:")
        print("1. Convert to GGUF: python convert.py determina-ai-final")
        print("2. Quantize: ./quantize determina-ai.gguf determina-ai-q4_k_m.gguf Q4_K_M")
        print("3. Bundle with app")

def main():
    """Main training pipeline"""
    print("🚀 DeterminaAI Fine-Tuning Pipeline")
    print("=" * 50)
    
    # Initialize trainer
    trainer = DeterminaAITrainer(base_model="microsoft/phi-2")
    
    # Load model
    trainer.load_model()
    
    # Prepare dataset
    dataset = trainer.prepare_dataset("training_data.jsonl")
    tokenized_dataset = trainer.tokenize_dataset(dataset)
    
    # Train
    trainer.train(tokenized_dataset)
    
    # Save
    trainer.save_model()

if __name__ == "__main__":
    main()
