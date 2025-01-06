# Quizmaster Dev Environment Container
This is a Dockerfile for a self-contained development environment for
[Quizmaster](https://github.com/scrumdojo/quizmaster) project.

It is configured to run both in Docker and Podman, and connect to from VS Code or IntelliJ running on any host operating system.

- [Run in Podman](docs/podman.md)
- Run in Docker (TODO)
- [Open in VS Code (or Cursor)](docs/vscode.md)
- [Open in IntelliJ IDEA](docs/intellij.md)

# Git Config
After you setup the container, do not forget to config your user name and email for `git` inside the container:

```
git config --global user.name "Your Name"
git config --global user.email "youremail@yourdomain.com"
```

# Login to GitHub
Create a personal access token in your GitHub profile. Go to Settings > Developer Settings (at the very bottom of the left menu).

Authenticate to GitHub using GitHub CLI (preinstalled in the container) and follow the instructions on the screen.

```
gh auth login
```
