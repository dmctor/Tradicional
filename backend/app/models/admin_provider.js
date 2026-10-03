const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');
const Admin = require('./admin'); // Importamos el modelo Admin
const Provider = require('./provider'); // Importamos el modelo Provider

const AdminProvider = sequelize.define('AdminProvider', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    admin_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Admin,  // Se hace referencia al modelo Admin
            key: 'id'      // El campo al que se hace referencia es 'id' en Admin
        }
    },
    provider_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Provider,  // Se hace referencia al modelo Provider
            key: 'id'         // El campo al que se hace referencia es 'id' en Provider
        }
    }
}, {
    tableName: 'admin_providers',
    timestamps: false
});

// Definimos la relación con Admin
AdminProvider.belongsTo(Admin, {
    foreignKey: 'admin_id',
    as: 'admin' // Alias opcional para usar en consultas
});

// Definimos la relación con Provider
AdminProvider.belongsTo(Provider, {
    foreignKey: 'provider_id',
    as: 'provider' // Alias opcional para usar en consultas
});

module.exports = AdminProvider;
