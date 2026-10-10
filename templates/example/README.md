# Example Themy module

This is the smallest complete module. Copy this directory as a starting point.

- `module.conf` identifies the module.
- `template.conf` is the metadata shown by Themy.
- `render` turns a palette into staged files and writes `.module-ok`.
- `apply` installs only staged files.
- `backup` saves the user's current files before apply.
- `restore` puts those files back after a failed apply or restore request.
- `doctor` reports optional module health information.
- `templates/example.conf` contains palette placeholders.

Keep rendering side-effect free. Put desktop-specific writes in `apply`, and use
`THEMY_XDG_CONFIG_HOME`, `THEMY_XDG_DATA_HOME`, and `THEMY_STAGE_DIR` instead
of hard-coded paths. Test a module with temporary XDG directories before using
it on a real desktop.
