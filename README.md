# whenever: run a command whenever some files/directories are changed

`whenever` is a simple terminal utility (implemented in about 50 lines of bash)
that lets you run a command whenever some files or directories are changed.

## Installation

Everything is self-contained in the bash script `whenever.sh`.
Download the script `whenever.sh` and make a link using
```sh
ln -si path/to/whenever.sh /usr/local/bin/whenever
```
where `path/to/whenever.sh` is the path to the downloaded script.

## Usage

```
USAGE: whenever [command] <<< [files|directories]
DESCRIPTION:
    Run [command] whenever [files|directories] are modified. Files/directories
    that are watched for changes are passed to whenever via stdin, this
    usually means piping [files|directories] to whenever, see EXAMPLES.
    Please do not have any special characters in the filenames.
EXAMPLES:
    # echo "hmmm" whenever any file in the current directory is modified.
    find . -type f | whenever echo "hmmm"

    # Convert markdown to html whenever the file itself, the style sheet,
    # or any thing in the src directory is modified.
    echo index.md style.css src/ | whenever pandoc index.md --output index.html
ENVIRONMENT:
    WHENEVER_INTERVAL    The interval in seconds to check for changes. Default
                         is 1 second, it is currently set to 1 second(s).

    WHENEVER_COMMAND     The command used to check whether files are modified.
                         Default is `md5sum`, it is currently set to `md5sum`.
```

## License

License: GPL-3</br>
Copyright 2025 Jesse C. Chen
