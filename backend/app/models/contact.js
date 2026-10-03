const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');
const Dependency = require('./dependency'); // Importamos el modelo Dependency

const Contact = sequelize.define('Contact', {
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

    name: {
        type: DataTypes.STRING(255),
        allowNull: false
    },

    last_name: {
        type: DataTypes.STRING(255),
        allowNull: false
    },

    cellphone: {
        type: DataTypes.STRING(255),
        allowNull: false
    },

    rank: {
        type: DataTypes.STRING(255),
        allowNull: false
    },

    position: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    
    birthday: {
        type: DataTypes.STRING(255),
        allowNull: false
    }
}, {
    tableName: 'contacts',
    timestamps: false
});

// Definimos la relación con Dependency
Contact.belongsTo(Dependency, {
    foreignKey: 'dependency_id',
    as: 'dependency' // Alias opcional para usar en consultas
});

module.exports = Contact;