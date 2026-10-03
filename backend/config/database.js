const { Sequelize } = require('sequelize');

// Crear la conexión a SQLite
const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: './db/app.db',  // Ruta donde se guardará el archivo SQLite
    logging: false,
    retry: {
        max: 3 // Reintentará hasta 3 veces antes de fallar
      } // Opcional: desactiva logs SQL en la consola
});

module.exports = sequelize;
