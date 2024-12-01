#!/usr/bin/env python3
# scripts/generate_tree.py

import os
from pathlib import Path
import argparse
from typing import List, Set, Optional

def generate_tree(
    directory: str = '.',
    prefix: str = '',
    exclude_dirs: Optional[Set[str]] = None,
    max_depth: Optional[int] = None,
    current_depth: int = 0
) -> List[str]:
    """
    Generates a directory tree in ASCII format.
    
    Example output:
    .
    ├── folder1
    │   ├── file1.txt
    │   └── file2.txt
    └── folder2
        └── file3.txt
    
    Args:
        directory: Starting directory path
        prefix: Current line prefix for ASCII art
        exclude_dirs: Set of directory names to exclude
        max_depth: Maximum depth to traverse (None for unlimited)
        current_depth: Current traversal depth
    
    Returns:
        List of strings representing tree lines
    """
    if exclude_dirs is None:
        exclude_dirs = {
            '.git',           # Version control
            '__pycache__',    # Python bytecode cache
            'node_modules',   # NPM dependencies
            '.venv',          # Python virtual env
            '.terraform',     # Terraform state and plugins
            'jenkins_home',   # Jenkins workspace/data
            '.aws',           # AWS credentials and config
            'venv',          # Another common virtual env name
            'dist',          # Distribution/build files
            'build',         # Build artifacts
            'coverage',      # Test coverage reports
            '.pytest_cache',  # Pytest cache
            '.DS_Store',     # macOS system files
            '__MACOSX'       # macOS system files
        }
    
    if max_depth is not None and current_depth > max_depth:
        return []
        
    path = Path(directory)
    items = sorted(path.glob('*'))
    
    # Filter out excluded directories
    items = [item for item in items if item.name not in exclude_dirs]
    
    tree = []
    for index, item in enumerate(items):
        is_last = index == len(items) - 1
        node = '└──' if is_last else '├──'
        tree.append(f'{prefix}{node} {item.name}')
        
        if item.is_dir():
            extension = '    ' if is_last else '│   '
            tree.extend(
                generate_tree(
                    item,
                    prefix + extension,
                    exclude_dirs,
                    max_depth,
                    current_depth + 1
                )
            )
            
    return tree

def main():
    """
    Main function to handle command-line arguments and generate the tree.
    """
    parser = argparse.ArgumentParser(description='Generate ASCII directory tree')
    parser.add_argument('--root', default='.', help='Root directory to start from')
    parser.add_argument('--max-depth', type=int, help='Maximum depth to traverse')
    parser.add_argument('--output', help='Output file (stdout if not specified)')
    args = parser.parse_args()

    # Generate tree
    tree_output = '\n'.join(['.'] + generate_tree(
        args.root,
        max_depth=args.max_depth
    ))

    # Output results
    if args.output:
        with open(args.output, 'w') as f:
            f.write(tree_output)
    else:
        print(tree_output)

if __name__ == '__main__':
    main()