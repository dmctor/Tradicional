const express = require("express");
const Contact = require("../models/contact");
const Dependency = require("../models/dependency");
const { jwtMiddleware } = require("../../config/middlewares");

const router = express.Router();

// GET: /contacts
router.get("/", jwtMiddleware, async (req, res) => {
  try {
    const contacts = await Contact.findAll();
    res.status(200).json(contacts);
  } catch (error) {
    console.error("Error al obtener contactos:", error);
    res.status(500).json({
      message: "Error al obtener contactos",
      detail: error.message
    });
  }
});

// GET: /contacts/:id
router.get("/:id", jwtMiddleware, async (req, res) => {
  const { id } = req.params;

  if (!id || isNaN(id)) {
    return res.status(400).json({
      message: "ID de contacto inválido",
      detail: ""
    });
  }

  try {
    const contact = await Contact.findByPk(id);

    if (!contact) {
      return res.status(404).json({
        message: "Contacto no encontrado",
        detail: ""
      });
    }

    res.status(200).json(contact);
  } catch (error) {
    console.error("Error al obtener contacto:", error);
    res.status(500).json({
      message: "Error al obtener contacto",
      detail: error.message
    });
  }
});

// GET: /contacts/dependency/:dependency_id
router.get("/dependency/:dependency_id", jwtMiddleware, async (req, res) => {
  const { dependency_id } = req.params;

  if (!dependency_id || isNaN(dependency_id)) {
    return res.status(400).json({
      message: "ID de dependencia inválido",
      detail: ""
    });
  }

  try {
    const contacts = await Contact.findAll({
      where: { dependency_id },
    });

    if (contacts.length === 0) {
      return res.status(404).json({
        message: "No se encontraron contactos para esta dependencia",
        detail: ""
      });
    }

    res.status(200).json(contacts);
  } catch (error) {
    console.error("Error al obtener contactos por dependencia:", error);
    res.status(500).json({
      message: "Error al obtener contactos por dependencia",
      detail: error.message
    });
  }
});

module.exports = router;
