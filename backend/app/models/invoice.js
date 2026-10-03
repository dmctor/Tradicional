const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Invoice = sequelize.define('Invoice', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    invoice_number: {
        type: DataTypes.STRING(50),
        allowNull: false
    },
    service_type: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    service_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    invoice_month: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    invoiced: {
        type: DataTypes.BOOLEAN,
        allowNull: false
    },
    issue_date: {
        type: DataTypes.DATE,
        allowNull: false
    },
    due_date: {
        type: DataTypes.DATE,
        allowNull: false
    }
}, {
    tableName: 'invoices',
    timestamps: false
});

module.exports = Invoice;
