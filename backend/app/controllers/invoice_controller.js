const express = require("express");
const { jwtMiddleware } = require("../../config/middlewares");
const Invoice = require("../models/invoice"); // Importamos el modelo Invoice
const router = express.Router();

// GET: /invoices/isp
router.post("/isp", jwtMiddleware, async (req, res) => {
  const { ispServices } = req.body; // Recibimos la lista de servicios ISP

  let response = {};
  let status = null;

  try {
    if (!Array.isArray(ispServices) || ispServices.length === 0) {
      response = {
        message: "No se enviaron servicios ISP válidos.",
        detail: "",
      };
      status = 400;
    } else {
      const ids = ispServices.map((service) => service.id);
      const invoices = await Invoice.findAll({
        where: {
          service_type: "ISP",
          service_id: ids
        }
      });

      if (invoices.length > 0) {
        response = invoices;
        status = 200;
      } else {
        response = {
          message: "No se encontraron facturas para los servicios ISP.",
          detail: "",
        };
        status = 404;
      }
    }
  } catch (error) {
    console.error("Error al obtener facturas ISP:", error);
    response = {
      message: "Ocurrió un error al obtener las facturas ISP",
      detail: error.message,
    };
    status = 500;
  }

  res.status(status).json(response);
});

// GET: /invoices/provider
router.post("/provider", jwtMiddleware, async (req, res) => {
  const { providerServices } = req.body; // Recibimos la lista de servicios Provider

  let response = {};
  let status = null;

  try {
    if (!Array.isArray(providerServices) || providerServices.length === 0) {
      response = {
        message: "No se enviaron servicios Proveedor válidos.",
        detail: "",
      };
      status = 400;
    } else {
      const ids = providerServices.map((service) => service.id);
      const invoices = await Invoice.findAll({
        where: {
          service_type: "Proveedor",
          service_id: ids
        }
      });

      if (invoices.length > 0) {
        response = invoices;
        status = 200;
      } else {
        response = {
          message: "No se encontraron facturas para los servicios Proveedor.",
          detail: "",
        };
        status = 404;
      }
    }
  } catch (error) {
    console.error("Error al obtener facturas Proveedor:", error);
    response = {
      message: "Ocurrió un error al obtener las facturas Proveedor",
      detail: error.message,
    };
    status = 500;
  }

  res.status(status).json(response);
});

// POST: /invoices/invoice
router.post("/invoice", jwtMiddleware, async (req, res) => {
  const { invoice } = req.body; // Recibimos la factura a actualizar

  let response = {};
  let status = null;

  try {
    const existingInvoice = await Invoice.findOne({
      where: {
        id: invoice.id
      }
    });

    if (!existingInvoice) {
      response = {
        message: "Factura no encontrada.",
        detail: "",
      };
      status = 404;
    } else {
      existingInvoice.invoiced = true;
      await existingInvoice.save();

      response = {
        message: "Factura marcada como facturada.",
        detail: "",
      };
      status = 200;
    }
  } catch (error) {
    console.error("Error al facturar la factura:", error);
    response = {
      message: "Ocurrió un error al marcar la factura.",
      detail: error.message,
    };
    status = 500;
  }

  res.status(status).json(response);
});

module.exports = router;
