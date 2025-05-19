# whenever: run a command whenever a file/directory is changed

`whenever` is a simple terminal utility (implemented in about 50 lines of bash)
that lets you run a command whenever a file or directory is changed.

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
    that are watched for changes are passed to whenever via stdin, this usually
    means piping [files|directories] to whenever, see EXAMPLES. Please do not
    have any special characters in the filenames.
EXAMPLES:
    # echo "hmmm" whenever any file in the current directory is modified.
    find . -type f | whenever echo "hmmm"

    # Recompile LaTeX whenever the source file or style file is modified.
    echo paper.tex settings.sty | whenever pdflatex paper.tex
ENVIRONMENT:
    WHENEVER_INTERVAL    The interval in seconds to check for changes. Default
                         is 1 second.
    WHENEVER_COMMAND     The command used to check whether files are modified.
                         Default is md5sum.
```

## License

License: GPL-3</br>
Copyright 2025 Jesse C. Chen
