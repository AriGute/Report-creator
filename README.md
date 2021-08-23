# Data-Security-Project

Secured messanger app for data security course.

## The Project:

The project is about a secured P2P messenger app, every message is encrypt end-to-end using Diffie-Hellman for swapping keys.
Each connected user get a token after authentication from the server.
Message without a token cant get to its destination.

Demonstration video: https://youtu.be/dNhx2mX61gk

## Project Purpose

**The project must meet a number of conditions:**

- Able to send and recive messages
- Each message is encrypted end-to-end
- User authentication

## Getting Started

1. Run KDCgui.
2. Enter user name and password and click "Add new User" (need to add at least 2 users).
3. In KDCgui click "Start Server".
4. Run guiLayOut(one for each user).
5. Enter username and password in each client and click "Connect".
6. At this point bouth clients should recive a message "Connected to remote host..".
7. Send and recive messages.

## Authors

- **Ariel Gueta**
- **Joaffzie**
- **lidorz51**
- **Yarin Edri**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
