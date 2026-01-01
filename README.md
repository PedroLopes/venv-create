# venv-create

`venv-create` is a small Bash utility that creates and activates a
Python virtual environment based on the name of the current directory.

It is designed to remove friction when starting a new Python project by
enforcing a simple, predictable convention.

By default, the virtual environment name is the same as the current
working directory, but this can be overridden via a command-line option (``--name```).

## What this does

-   Automatically names the virtual environment after the current
    directory
-   Uses Python's built-in `venv` module
-   Refuses to overwrite existing directories unless explicitly forced
-   Creates a new shell with the virtual environment activated (you can exit this subshell with ``deactivate``, which also will deactivate the virtual environment as the subshell closes)

## Automatic installation


``` bash
chmod +x install.sh
./install.sh
```

This will install the tool in your path (restart your shell/terminal after install), so that you can invoke it anywhere with ``venv-create``

## Manual installation

Place the script somewhere on your `PATH`, for example:

``` bash
chmod +x venv-create
mv venv-create ~/.local/bin/
```

Ensure `~/.local/bin` is on your `PATH`.

## Usage

From inside a project directory:

``` bash
venv-create
```

This will:

1.  Use the current directory name as the virtual environment name
2.  Create a new virtual environment with `python -m venv`
3.  Start a new Bash subshell with the environment activated

To leave the virtual environment, run:

``` bash
deactivate
```

This exits the subshell and returns you to your original shell.

## Options

  -----------------------------------------------------------------------
  Option                 Description
  ---------------------- ------------------------------------------------
  `-n`, `--name <name>`  Explicitly set the virtual environment directory
                         name

  `-f`, `--force`        Overwrite an existing directory if it already
                         exists

  `-q`, `--quiet`        Suppress non-error output

  `-v`, `--verbose`      Print detailed execution information
  -----------------------------------------------------------------------

### Examples

Create a virtual environment named after the current directory:

``` bash
venv-create
```

Create a virtual environment with a custom name:

``` bash
venv-create --name .venv
```

Force creation even if the directory already exists:

``` bash
venv-create --force
```

## Behavior Notes

-   The script launches a new interactive Bash shell to activate the
    virtual environment. This is required because a child process cannot
    modify the parent shell's environment.
-   The `deactivate` command is provided as an alias to `exit` in the
    subshell.

## Safety

If a directory with the target name already exists, `venv-create` will
abort unless `--force` is specified. This prevents accidental
overwrites.

## Limitations

-   Python discovery currently uses `which python3`
-   Designed for interactive use rather than scripting
-   Assumes a Bash-compatible shell

## License

GNU GPL
