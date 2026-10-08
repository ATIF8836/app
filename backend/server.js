const express = require('express');
const http = require('http');
const cors = require('cors');
const { Server } = require('socket.io');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Yello Ludo backend is running');
});

const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
    credentials: false,
  },
});

const rooms = {};

function generateRoomCode(length = 6) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let result = '';

  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }

  return result;
}

function getUniqueRoomCode() {
  let code = generateRoomCode();

  while (rooms[code]) {
    code = generateRoomCode();
  }

  return code;
}

io.on('connection', (socket) => {
  console.log('A user connected:', socket.id);

  socket.on('create_room', (data) => {
    console.log('Create room request:', data);

    const name = data?.name?.trim();

    if (!name) {
      socket.emit('error_message', { message: 'Name is required' });
      return;
    }

    const roomCode = getUniqueRoomCode();

    rooms[roomCode] = {
      roomCode,
      hostId: socket.id,
      gameStarted: false,
      players: [
        {
          id: socket.id,
          name,
        },
      ],
    };

    socket.join(roomCode);

    console.log('Generated room code:', roomCode);
    console.log('Room object saved:', rooms[roomCode]);
    console.log('Socket joined room:', roomCode);

    socket.emit('room_created', {
      roomCode,
      players: rooms[roomCode].players,
    });

    console.log('room_created emitted successfully');
  });

  socket.on('join_room', (data) => {
    console.log('Join room request:', data);

    const name = data?.name?.trim();
    const roomId = data?.roomId?.trim()?.toUpperCase();

    if (!name || !roomId) {
      socket.emit('error_message', {
        message: 'Name and room code are required',
      });
      return;
    }

    const room = rooms[roomId];

    if (!room) {
      socket.emit('error_message', { message: 'Room not found' });
      return;
    }

    if (room.gameStarted) {
      socket.emit('error_message', { message: 'Game already started' });
      return;
    }

    const alreadyInRoom = room.players.some((player) => player.id === socket.id);

    if (!alreadyInRoom) {
      room.players.push({
        id: socket.id,
        name,
      });
    }

    socket.join(roomId);

    io.in(roomId).emit('room_joined', {
      roomCode: roomId,
      players: room.players,
    });

    console.log('room_joined emitted successfully');
  });

  socket.on('start_game', (data) => {
    console.log('Start game request:', data);

    const roomId = data?.roomId?.trim()?.toUpperCase();

    if (!roomId) {
      socket.emit('error_message', { message: 'Room ID is required' });
      return;
    }

    const room = rooms[roomId];

    if (!room) {
      socket.emit('error_message', { message: 'Room not found' });
      return;
    }

    if (room.hostId !== socket.id) {
      socket.emit('error_message', {
        message: 'Only the host can start the game',
      });
      return;
    }

    if (room.players.length < 2) {
      socket.emit('error_message', {
        message: 'At least 2 players are required',
      });
      return;
    }

    room.gameStarted = true;

    io.in(roomId).emit('game_started', {
      roomCode: roomId,
      players: room.players,
    });

    console.log('game_started emitted successfully:', roomId);
  });

  socket.on('send_room_chat', (data) => {
    const roomCode = data?.roomCode?.trim()?.toUpperCase();
    const message = data?.message?.trim();

    if (!roomCode || !message) return;

    const room = rooms[roomCode];
    if (!room) return;

    const isInRoom = room.players.some((player) => player.id === socket.id);
    if (!isInRoom) return;

    io.in(roomCode).emit('room_chat_message', {
      roomCode,
      message,
      senderId: socket.id,
    });
  });

  socket.on('voice_uid', (data) => {
    const agoraUid = data?.agoraUid;

    if (!agoraUid) return;

    for (const roomCode in rooms) {
      const room = rooms[roomCode];
      const isInRoom = room.players.some((player) => player.id === socket.id);

      if (isInRoom) {
        io.in(roomCode).emit('voice_uid_update', {
          socketId: socket.id,
          agoraUid,
        });
        break;
      }
    }
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);

    for (const roomCode in rooms) {
      const room = rooms[roomCode];
      const playerIndex = room.players.findIndex(
        (player) => player.id === socket.id
      );

      if (playerIndex !== -1) {
        room.players.splice(playerIndex, 1);

        if (room.players.length === 0) {
          delete rooms[roomCode];
          console.log('Deleted empty room:', roomCode);
        } else {
          if (room.hostId === socket.id) {
            room.hostId = room.players[0].id;
            console.log('New host assigned in room:', roomCode);
          }

          io.in(roomCode).emit('room_joined', {
            roomCode,
            players: room.players,
          });
        }

        break;
      }
    }
  });
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
});
