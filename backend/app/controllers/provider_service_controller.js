const express = require("express");
const ProviderService = require("../models/provider_service"); // Importamos el modelo ProviderService
const router = express.Router();
const { jwtMiddleware } = require("../../config/middlewares");

// GET: providerServices/by-provider
router.post("/by-provider", jwtMiddleware, async (req, res) => {
  const { providerId } = req.body; // Recibimos el ID del proveedor

  let response = {};
  let status = null;

  try {
    // Consultamos los servicios asociados a ese proveedor
    const providerServices = await ProviderService.findAll({
      where: {
        provider_id: providerId
      }
    });

    if (providerServices.length > 0) {
      response = providerServices;
      status = 200;
    } else {
      response = {
        message: "No se encontraron servicios para este proveedor.",
        detail: "",
      };
      status = 404;
    }
  } catch (error) {
    console.error("Error al obtener servicios del proveedor:", error);
    response = {
      message: "Ocurrió un error al obtener los servicios",
      detail: error.message,
    };
    status = 500;
  }

  res.status(status).json(response);
});

// POST: /providerServices/create
router.post("/create", jwtMiddleware, async (req, res) => {
  const { description, dependencyId, providerId, price } = req.body; // Recibimos los datos para el nuevo servicio

  let response = {};
  let status = null;

  try {
    // Comprobamos si ya existe un servicio con la misma descripción, proveedor y dependencia
    const existingService = await ProviderService.findOne({
      where: {
        description: description,
        provider_id: providerId,
        dependency_id: dependencyId  
      }
    });

    if (existingService) {
      response = {
        message: "El servicio con esta descripción ya existe para este proveedor y dependencia.",
        detail: "",
      };
      status = 409; // Conflicto
    } else {
      // Creamos el nuevo servicio
      const newService = await ProviderService.create({
        description,
        provider_id: providerId,
        dependency_id: dependencyId,
        price
      });

      response = {
        message: "Servicio creado correctamente.",
        detail: "",
      };
      status = 201; // Creado
    }
  } catch (error) {
    console.error("Error al crear el servicio:", error);
    response = {
      message: "Ocurrió un error al crear el servicio",
      detail: error.message,
    };
    status = 500;
  }

  res.status(status).json(response);
});

module.exports = router;
