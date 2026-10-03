const express = require("express");
const Dependency = require("../models/dependency");
const Provider = require("../models/provider");
const router = express.Router();
const { jwtMiddleware } = require("../../config/middlewares");

// GET: /dependencies
router.get("/", jwtMiddleware, async (req, res) => {
  try {
    const dependencies = await Dependency.findAll();
    res.status(200).json(dependencies);
  } catch (error) {
    console.error("Error al obtener dependencias:", error);
    res.status(500).json({
      message: "Error al obtener dependencias",
      detail: error.message,
    });
  }
});

// GET: /dependencies/:id
router.get("/:id", jwtMiddleware, async (req, res) => {
  const { id } = req.params;

  try {
    const dependency = await Dependency.findByPk(id);
    if (!dependency) {
      return res.status(404).json({
        message: "Dependencia no encontrada",
        detail: "",
      });
    }

    res.status(200).json(dependency);
  } catch (error) {
    console.error("Error al obtener dependencia:", error);
    res.status(500).json({
      message: "Error al obtener dependencia",
      detail: error.message,
    });
  }
});

// GET: /dependencies/provider/:provider_id/company/:company_id
router.get("/provider/:provider_id/company/:company_id", jwtMiddleware, async (req, res) => {
  const { provider_id, company_id } = req.params;

  try {
    const dependencies = await Dependency.findAll({
      where: {
        provider_id,
        company_id
      },
    });

    if (dependencies.length === 0) {
      return res.status(404).json({
        message: "No se encontraron dependencias para el proveedor y la compañía especificados",
        detail: "",
      });
    }

    res.status(200).json(dependencies);
  } catch (error) {
    console.error("Error al obtener dependencias:", error);
    res.status(500).json({
      message: "Error al obtener dependencias",
      detail: error.message,
    });
  }
});

// GET: /dependencies/providers/names
router.get("/providers/names", jwtMiddleware, async (req, res) => {
  try {
    const providers = await Provider.findAll({
      attributes: ['id', 'name']
    });

    if (providers.length === 0) {
      return res.status(404).json({
        message: "No se encontraron proveedores",
        detail: "",
      });
    }

    const formatted = providers.map(p => ({ id: p.id, name: p.name }));
    res.status(200).json(formatted);
  } catch (error) {
    console.error("Error al obtener nombres de proveedores:", error);
    res.status(500).json({
      message: "Error al obtener nombres de proveedores",
      detail: error.message,
    });
  }
});

module.exports = router;
