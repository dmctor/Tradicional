const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');
const Address = require('./address'); // Importamos el modelo Address

const Company = sequelize.define('Company', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    address_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Address,
            key: 'id'
        }
    },
    ruc: {
        type: DataTypes.STRING,
        allowNull: false
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    tableName: 'companies',
    timestamps: false
});

// Relación con Address
Company.belongsTo(Address, {
    foreignKey: 'address_id',
    as: 'address'
});

module.exports = Company;
