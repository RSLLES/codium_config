import sys
import json

def process(filepath : str) -> bool:
    """Ensure a json file is sorted with good indenting; return true if file was edited."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            original_data = json.load(f)
    except json.JSONDecodeError:
        print(f"Skipping invalid JSON: {filepath}")
        return False

    sorted_content = json.dumps(original_data, sort_keys=True, indent=2) + "\n"

    with open(filepath, 'r', encoding='utf-8') as f:
        original_content = f.read()

    if original_content == sorted_content:
        return False

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(sorted_content)
    
    print(f"Sorted JSON: {filepath}")
    return True

if __name__ == "__main__":
    files_changed = False
    
    for filename in sys.argv[1:]:
        if process(filename):
            files_changed = True

    if files_changed:
        sys.exit(1)
