import os
import pandas as pd

def split_accessions(file_path, chunk_size=20):
    df = pd.read_csv(file_path, header=None, names=['accession'])
    
    # Folder for output
    output_folder = 'accession_numbers'
    
    for i in range(0, len(df), chunk_size):
        chunk = df.iloc[i:i + chunk_size]
        start = i + 1
        end = i + len(chunk)
        output_filename = os.path.join(output_folder, f"accession_{start}_{end}.txt")
        
        chunk.to_csv(output_filename, index=False, header=False)
        print(f"Created {output_filename}")

# Run the function with the accession file
split_accessions("accessions.txt")