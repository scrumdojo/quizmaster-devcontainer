# Open project in IntelliJ IDEA Ultimate
To connect to the Quizmaster development environment container, follow these steps:

1. On the IntelliJ IDEA Welcome screen, select "Remote Development > SSH". Press New Project button.

3. Create a new Connection (cog icon on the right):
    - Host: `localhost`
    - Port: `2222`
    - Username: `dev`
    - Authentication type: Password
    - Password: `dev`

4. Connect to the newly created Connection.

5. In the "Choose IDE and Project" screen
    - Select IDE version (recommended latest non-RC release)
    - Select Project directory: `/home/dev/quizmaster`
