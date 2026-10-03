const express = require("express");
const Provider = require("../models/provider"); // Importamos el modelo Provider
const router = express.Router();
const { jwtMiddleware } = require("../../config/middlewares");

// POST: Fetch providers by IDs
router.post("/fetch-by-ids", jwtMiddleware, async (req, res) => {
  const { ids } = req.body; // Recibimos los IDs de los proveedores

  let response = {};
  let status = null;

  try {
    // Verificamos si 'ids' es un arreglo no vacío
    if (!Array.isArray(ids) || ids.length === 0) {
      response = {
        message: "Debe enviar un arreglo de IDs de proveedores",
        detail: "",
      };
      status = 400; // Si no es un arreglo o está vacío, devolvemos error 400
    } else {
      // Buscar proveedores en la base de datos que coincidan con los IDs proporcionados
      const providers = await Provider.findAll({
        where: {
          id: ids, // Filtramos los proveedores por los IDs
        },
        attributes: ['id', 'ruc', 'name', 'logo'], // Especificamos qué campos queremos que nos devuelva
      });

      // Si se encuentran proveedores, devolvemos una respuesta 200
      if (providers.length > 0) {
        status = 200;
        response = providers; // Devolvemos la lista de proveedores
      } else {
        // Si no se encuentran proveedores, respondemos con un error 400
        status = 400;
        response = {
          message: "Hubo un error al encontrar los proveedores",
          detail: "No se encontraron proveedores con los IDs proporcionados",
        };
      }
    }
  } catch (error) {
    console.error("Error al buscar proveedores:", error);
    status = 500; // Error interno del servidor
    response = {
      message: "Error al buscar proveedores",
      detail: error,
    };
  }

  // Enviar la respuesta con el status correspondiente
  res.status(status).json(response);
});

module.exports = router;
