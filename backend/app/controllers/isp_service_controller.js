const express = require('express');
const ISPService = require('../models/isp_service');
const router = express.Router();
const { jwtMiddleware } = require("../../config/middlewares");
// GET /ispServices/provider/:provider_id (opcional)
router.get('/provider/:provider_id', jwtMiddleware, async (req, res) => {
 const { provider_id } = req.params;  // extraemos provider_id desde la URL

  try {
    let services;

    if (provider_id) {
      // Filtrar solo por el provider_id recibido
      services = await ISPService.findAll({
        where: { provider_id }
      });
    } else {
      // Si no viene provider_id, devolver todos
      services = await ISPService.findAll();
    }

    if (!services || services.length === 0) {
      return res.status(404).json({
        message: "No se encontraron servicios para el proveedor especificado",
        detail: "",
      });
    }

    res.status(200).json(services);

  } catch (error) {
    console.error("❌ Error al obtener servicios ISP:", error);
    res.status(500).json({
      message: "Error al obtener servicios",
      detail: error.message,
    });
  }
});
// GET /ispServices/:id
router.get('/:id', jwtMiddleware, async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const service = await ISPService.findByPk(id);
    if (service) {
      res.status(200).json(service);
    } else {
      res.status(404).json({ message: 'Servicio no encontrado' });
    }
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener el servicio', error: err });
  }
});

// POST /ispServices
router.post('/', jwtMiddleware, async (req, res) => {
  const { isp_id, provider_id, description, cost, pay_code } = req.body;
  console.log("📥 POST /isp_services - Body recibido:", req.body);

  if (!isp_id || !provider_id || !description || !cost || !pay_code) {
    console.log("⚠️ POST /isp_services - Faltan campos obligatorios");
    return res.status(400).json({ message: 'Faltan campos obligatorios' });
  }
  
  try {
    const newService = await ISPService.create({
      isp_id,
      provider_id,
      description,
      cost,
      pay_code
    });
    console.log("✅ POST /isp_services - Servicio creado correctamente:", newService);
    res.status(201).json(newService);
  } catch (err) {
    console.error("❌ POST /isp_services - Error al crear servicio:", err);
    res.status(500).json({ message: 'Error al crear servicio', error: err });
  }
});

module.exports = router;

