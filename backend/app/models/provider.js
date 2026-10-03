const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Provider = sequelize.define('Provider', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    ruc: {
        type: DataTypes.STRING(11), // Asegúrate que el RUC tenga 11 caracteres
        allowNull: false
    },
    name: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    logo: {
        type: DataTypes.STRING(255), // El logo puede ser una URL o el nombre de un archivo
        allowNull: true
    }
}, {
    tableName: 'providers',
    timestamps: false
});

module.exports = Provider;
