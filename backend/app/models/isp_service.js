const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const ISPService = sequelize.define('isp_services', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  isp_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  provider_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  description: {
    type: DataTypes.STRING,
    allowNull: false
  },
  cost: {
    type: DataTypes.FLOAT,
    allowNull: false
  },
  pay_code: {
    type: DataTypes.STRING,
    allowNull: false
  }
}, {
  tableName: 'isp_services',
  timestamps: false
});

module.exports = ISPService;

