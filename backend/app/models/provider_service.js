const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');
const Provider = require('./provider');
const Dependency = require('./dependency'); 

const ProviderService = sequelize.define('ProviderService', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    dependency_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Dependency,
            key: 'id'
        }
    },
    provider_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Provider,
            key: 'id'
        }
    },
    description: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    price: {
        type: DataTypes.FLOAT,
        allowNull: false
    }
}, {
    tableName: 'provider_services',
    timestamps: false
});

// Definimos la relación con Provider
ProviderService.belongsTo(Provider, {
    foreignKey: 'provider_id',
    as: 'provider' // Alias opcional para usar en consultas
});

// Relación opcional si quieres asociar con Dependency
ProviderService.belongsTo(Dependency, {
    foreignKey: 'dependency_id',
    as: 'dependency' // Alias opcional para usar en consultas
});

module.exports = ProviderService;