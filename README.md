# whenever: run a command whenever a file/directory is changed

`whenever` is a simple terminal utility that lets you run a command whenever a file or directory is changed.
`whenever` is implemented in about 50 lines of bash script.

## Installation

Everything is self-contained in the bash script `whenever.sh`.
Download the script `whenever.sh` and make a link using
```sh
ln -si path/to/whenever.sh /usr/local/bin/whenever
```
where `path/to/whenever.sh` is the path to the downloaded script.

## Usage

```
usage: whenever [file|dir] [command]
description: run [command] whenever [file|dir] is modified.
```

For example, the following command will echo `Hello` whenever `file.txt` is modified:
```sh
whenever file.txt echo "Hello"
```
`whenever` will display a message and keep count on the times `[file]` is modified and `[command]` is run.

## Settings

Here are some variables that can be customized:

- `WHENEVER_COMMAND`: The command used to check whether files are modified. (default: `md5sum`)
- `WHENEVER_INTERVAL`: Time interval (in second) between checks. (default: `1`, i.e., check for changes once every second)

## License

License: GPL-3</br>
Copyright 2023 Jesse C. Chen
