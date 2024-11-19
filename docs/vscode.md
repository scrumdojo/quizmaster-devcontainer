# Visual Studio Code or Cursor
To open the Quizmaster repository in VS Code or [Cursor](https://www.cursor.com/),
you need the [Remote SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension installed.

## Add New SSH Host
1. Open command pallette (F1 or Ctrl+Shift+P), type `remote ssh`, select "Remote-SSH: Add New SSH Host...".
2. Type `ssh -p 2222 dev@localhost` and select SSH configuration file to update.
3. Open the SSH config file from the flyout, and rename the `Host` to `quizmaster-dev`:
    ```
    Host quizmaster-dev
        HostName localhost
        Port 2222
        User dev
    ```

## Connect to SSH Host
1. Open command pallette, type `remote ssh`, select "Remote-SSH: Connect to Host..."
2. Select `quizmaster-dev` (or `localhost` if you haven't renamed the Host in the previous step 3.)
3. A new window opens, follow the instructions at the top. You may need to enter the `dev` user password more than once.
4. Wait for the VS Code Server to download.
5. Open folder `/home/dev/quizmaster`

To check everything works, open a terminal in VS Code, and run:
```
cd quizmaster/backend
./gradlew testE2E
```
