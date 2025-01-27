# Testing commit
# Define the directories
CONFIG_DIR = .config
ML4W_HYPRLAND_DIR = .ml4w-hyprland
HOMEDIR = homeDir
SSH_DIR = .ssh

# Define the symlink creation command with relative path
LN_CMD = ln -sf

# Default target (dry-run)
dry-run: dry-run-config dry-run-ml4w-hyprland dry-run-homedir dry-run-ssh

# Dry run to simulate the creation of directories and symlinks
dry-run-config:
	cd $(HOME)/zdotfiles && find $(CONFIG_DIR) -type d -exec echo "Would create directory: $(HOME)/{}" \;
	cd $(HOME)/zdotfiles && find $(CONFIG_DIR) -type f -exec echo "Would symlink: $(HOME)/zdotfiles/{} -> $(HOME)/{}" \;

dry-run-ml4w-hyprland:
	cd $(HOME)/zdotfiles && find $(ML4W_HYPRLAND_DIR) -type d -exec echo "Would create directory: $(HOME)/{}" \;
	cd $(HOME)/zdotfiles && find $(ML4W_HYPRLAND_DIR) -type f -exec echo "Would symlink: $(HOME)/zdotfiles/{} -> $(HOME)/{}" \;

dry-run-homedir:
	cd $(HOME)/zdotfiles && find $(HOMEDIR) -type d -exec echo "Would create directory: $(HOME)/{}" \;
	cd $(HOME)/zdotfiles && find $(HOMEDIR) -type f -exec echo "Would symlink: $(HOME)/zdotfiles/{} -> $(HOME)/{}" \;

dry-run-ssh:
	cd $(HOME)/zdotfiles && find $(SSH_DIR) -type d -exec echo "Would create directory: $(HOME)/{}" \;
	cd $(HOME)/zdotfiles && find $(SSH_DIR) -type f -exec echo "Would symlink: $(HOME)/zdotfiles/{} -> $(HOME)/{}" \;

# Target for actual run
run-all: config-actual ml4w-hyprland-actual homedir-actual ssh-actual

# Actual targets for creating symlinks
config-actual:
	cd $(HOME)/zdotfiles && find $(CONFIG_DIR) -type d -exec mkdir -p $(HOME)/{} \;
	cd $(HOME)/zdotfiles && find $(CONFIG_DIR) -type f -exec $(LN_CMD) $(HOME)/zdotfiles/{} $(HOME)/{} \;

ml4w-hyprland-actual:
	cd $(HOME)/zdotfiles && find $(ML4W_HYPRLAND_DIR) -type d -exec mkdir -p $(HOME)/{} \;
	cd $(HOME)/zdotfiles && find $(ML4W_HYPRLAND_DIR) -type f -exec $(LN_CMD) $(HOME)/zdotfiles/{} $(HOME)/{} \;

homedir-actual:
	cd $(HOME)/zdotfiles && find $(HOMEDIR) -type d -exec mkdir -p $(HOME)/{} \;
	cd $(HOME)/zdotfiles && find $(HOMEDIR) -type f -exec $(LN_CMD) $(HOME)/zdotfiles/{} $(HOME)/{} \;

ssh-actual:
	cd $(HOME)/zdotfiles && find $(SSH_DIR) -type d -exec mkdir -p $(HOME)/{} \;
	cd $(HOME)/zdotfiles && find $(SSH_DIR) -type f -exec $(LN_CMD) $(HOME)/zdotfiles/{} $(HOME)/{} \;

# Declare phony targets
.PHONY: dry-run dry-run-config dry-run-ml4w-hyprland dry-run-homedir dry-run-ssh config-actual ml4w-hyprland-actual homedir-actual ssh-actual
