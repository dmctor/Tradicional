const express = require("express");
const Company = require("../models/company");
const { jwtMiddleware } = require("../../config/middlewares");

const router = express.Router();

// Obtener todas las empresas
router.get("/", jwtMiddleware, async (req, res) => {
  try {
    const companies = await Company.findAll();
    res.status(200).json(companies);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener empresas", error });
  }
});

// Obtener RUC de una empresa por ID
router.get("/:id/ruc", jwtMiddleware, async (req, res) => {
  const { id } = req.params;
  try {
    const company = await Company.findByPk(id);
    if (!company) {
      return res.status(404).json({ message: "Empresa no encontrada" });
    }
    res.status(200).json({ ruc: company.ruc });
  } catch (error) {
    res.status(500).json({ message: "Error al obtener RUC", error });
  }
});

module.exports = router;
