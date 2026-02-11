import os

THEME_DIR = ".streamlit"
THEME_FILE = f"{THEME_DIR}/config.toml"

THEME_CONTENT = """
[theme]
base="dark"
primaryColor="#BB86FC"
backgroundColor="#1E1F22"
secondaryBackgroundColor="#2A2C31"
textColor="#E6E6E6"
"""

def ensure_theme():
    if not os.path.exists(THEME_DIR):
        os.makedirs(THEME_DIR)

    with open(THEME_FILE, "w", encoding="utf-8") as f:
        f.write(THEME_CONTENT)

if __name__ == "__main__":
    ensure_theme()
    print("✔ Tema gris oscuro configurado.")


