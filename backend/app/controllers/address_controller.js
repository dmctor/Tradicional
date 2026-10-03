const express = require("express");
const Company = require("../models/company");
const Address = require("../models/address");
const { jwtMiddleware } = require("../../config/middlewares");

const router = express.Router();

// Obtener la dirección asociada a una empresa
router.get("/company/:companyId", jwtMiddleware, async (req, res) => {
  const { companyId } = req.params;

  try {
    const company = await Company.findByPk(companyId, {
      include: {
        model: Address,
        as: 'address',
      },
    });

    if (!company) {
      return res.status(404).json({ message: "Empresa no encontrada" });
    }

    res.status(200).json(company.address);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener dirección", error });
  }
});

module.exports = router;
