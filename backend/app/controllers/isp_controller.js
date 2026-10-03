const express = require('express');
const ISP = require('../models/isp');
const Dependency = require('../models/dependency'); // 👈 NUEVO IMPORTANTE
const { jwtMiddleware } = require("../../config/middlewares");
const router = express.Router();

// GET /isps → todos los ISPs
router.get('/', jwtMiddleware, async (req, res) => {
  try {
    const isps = await ISP.findAll();
    const result = isps.map(isp => ({ id: isp.id, name: isp.name }));
    res.status(200).json(result);
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener ISPs', error: err });
  }
});

// GET /isps/:id → un ISP por ID
router.get('/:id', jwtMiddleware, async (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    const isp = await ISP.findByPk(id);
    if (isp) {
      res.status(200).json(isp);
    } else {
      res.status(404).json({ message: 'ISP no encontrado' });
    }
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener ISP', error: err });
  }
});

// POST /isps → agregar un ISP
router.post('/', jwtMiddleware, async (req, res) => {
  const { name, ruc } = req.body;

  if (!name) {
    return res.status(400).json({ message: 'Missing name' });
  }

  try {
    const newIsp = await ISP.create({ name, ruc });
    res.status(201).json(newIsp);
  } catch (err) {
    res.status(500).json({
      message: 'Error al crear ISP',
      error: err.message
    });
  }
});



module.exports = router;