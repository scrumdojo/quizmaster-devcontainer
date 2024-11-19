# Run in Podman
- [Prerequisites](#prerequisites)
- [Build Dev Environment Image](#build-dev-environment-image)
- [Create a Dev Environment Container](#create-a-dev-environment-container)

## Prerequisites
0. On Windows, make sure you have [WSL2 installed](https://learn.microsoft.com/en-us/windows/wsl/install):

    ```powershell
    wsl --install
    ```
1. [Install Podman](https://podman.io/docs/installation).
2. Optionally [install Podman Desktop](https://podman-desktop.io/downloads), if you prefer GUI.
3. On Windows, **reboot** your machine.
4. Create Podman machine:

    ```
    podman machine init
    podman machine start
    ```

## Build Dev Environment Image
Inside this repository's root run (takes 5-7min):
```
podman build -t quizmaster-devimage .
```
The resulting image takes cca 3.5 GB and has:

- Installed `git`, `sshd`, **Java 21 JDK** and **PostgreSQL 16**,

- **Linux user** `dev` with password `dev`, able to `sudo`,

- **PostgreSQL user** `dev` with password `dev` able to create users and databases,

- Cloned the [Quizmaster](https://github.com/scrumdojo/quizmaster) repository,

- Development **database** `quizmaster` and PostgreSQL user `quizmaster` with password `quizmaster`,

- Installed [pnpm](https://pnpm.io/), [Node.js](https://nodejs.org/en),
[Playwright](https://playwright.dev/) together with major browsers to run end-to-end tests, and,

- Exposed the following ports:
    - `22` for SSH (mapped later to `2222` while creating a container),
    - `5173` for Vite dev server,
    - `5432` for PostgreSQL server, and,
    - `8080` for the Spring Boot web app

## Create a Dev Environment Container
To create the development environment container, run:
```
podman run -it -d -p 2222:22 -p 8080:8080 -p 5432:5432 -p 5173:5173 --name  quizmaster-dev quizmaster-devimage
```

The container runs in the background, so that you can connect to it from your favorite IDE.

To check that everything works, connect to the container via SSH:
```
ssh -p 2222 dev@localhost
```
Inside the container run:
```
cd quizmaster/backend
./gradlew testE2E
```

To stop the container, run on your host OS:
```
podman stop quizmaster-dev
```

To restart the container, run on your host OS:
```
podman start quizmaster-dev
```
