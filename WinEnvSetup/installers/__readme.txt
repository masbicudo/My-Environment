Making an installer
===================

Use the file "__base.installer.bat" as a model to the main installer file.
Include a call to the created batch file in the "init-windows.bat" file.
Use the script tools inside the "tools" folder for various functions you may need:
 - get: download a file
 - append-system-env-var: appends a value to a system environment variable such as PATH or PATHEXT
 - append-system-env-var: appends a value to a user environment variable such as PATH
 - is-defined: checks whether an environment variable is set or not
 - sandboxie-diff: used to extract all changes made to a Sandboxie sandbox
        This can be used to extract changes made by an installer.
        Run the installer inside an empty sandbox, and then extract it's changes.
        You will get the md5 hash of all installed files, and a registry file with all keys and values written.
        Then you can edit the extracted info to make an installer validator, that can check the installation integrity.
 - set-error-level: sets an errorlevel that can be checked using:
        - IF ERRORLEVEL # ...
        - <command> && <True command>
        - <command> || <False command>
 - shct: create a shortcut (.lnk) file
 - test-md5: checks the md5 hash of a file and sets an errorlevel: 0 - match; 1 - does not match
 - text-replace: replaces text or regex from a file or the stdin, and saves the file or outputs to the stdout
 - unzip: unzips a zip compressed file
 - UpdateWindowsUI: updates the UI after setting registry values associated with Windows UI (e.g. mouse cursors)
