module.exports = (io) => {
  io.on('connection', (socket) => {
      console.log('✅ Un usuario se ha conectado');

      // Escuchar un evento personalizado (ejemplo: 'chat message')
      socket.on('chat message', (msg) => {
          console.log('💬 Mensaje recibido:', msg);
          // Reenviar el mensaje a TODOS los clientes conectados
          io.emit('chat message', msg);
      });

      socket.on('disconnect', () => {
          console.log('❌ Un usuario se ha desconectado');
      });
  });
};
