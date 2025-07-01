#!/usr/bin/env python3
from pathlib import Path
import sys

def project_root() -> Path:
    """
    Return a reliable base directory for relative paths.

    • If the program is a script (so __file__ exists), use the script’s parent folder.  
    • If it’s running in an interactive session or notebook where __file__ is absent,
      fall back to the current working directory.
    """
    main_mod = sys.modules.get('__main__')
    if getattr(main_mod, '__file__', None):
        return Path(main_mod.__file__).resolve().parent
    return Path.cwd()