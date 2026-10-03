const express = require("express");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const Admin = require("../models/admin");
const AdminProvider = require("../models/admin_provider"); // 👈 Nuevo

const router = express.Router();

// POST: Sign-in for admin login
router.post("/sign-in", async (req, res) => {
  const { username, password } = req.body;

  let response = {};
  let status = null;

  try {
    if (!username || !password) {
      response = {
        message: "Por favor complete todos los campos",
        detail: "Faltan usuario o contraseña",
      };
      status = 400;
    } else {
      /*async function generateHashes() {
  const passwords = [
    'password123',   // 👈 primer password
    'password456',     // 👈 segundo password
    'password789'   // 👈 tercer password
  ];

  const saltRounds = 10; // Nivel de complejidad

  for (let pass of passwords) {
    const hash = await bcrypt.hash(pass, saltRounds);
    console.log(`Password: ${pass}`);
    console.log(`Hash: ${hash}\n`);
  }
}

generateHashes();*/
      const admin = await Admin.findOne({
        attributes: ["id", "username", "password"],
        where: { username: username },
      });

      if (admin) {
        const passwordMatch = await bcrypt.compare(password, admin.password);

        if (passwordMatch) {
          // ✅ Buscar todos los provider_id relacionados a este admin
          const providerLinks = await AdminProvider.findAll({
            attributes: ["provider_id"],
            where: { admin_id: admin.id },
          });

          // ✅ Convertir resultado [{provider_id:1},{provider_id:2}] => [1,2]
          const providerIds = providerLinks.map((p) => p.provider_id);

          // ✅ Generar token
          const token = jwt.sign(
            {
              id: admin.id,
              username: admin.username,
            },
            process.env.JWT_SECRET || "fallback-secret-key",
            { expiresIn: "1h" }
          );

          // ✅ Devolver también providerIds
          status = 200;
          response = {
            admin: {
              id: admin.id,
              username: admin.username,
              listProvider: providerIds,
            },
            token,
          };
        } else {
          status = 401;
          response = {
            message: "Credenciales incorrectas",
            detail: false,
          };
        }
      } else {
        status = 404;
        response = {
          message: "Administrador no encontrado",
          detail: "",
        };
      }
    }
  } catch (error) {
    console.error("Error al validar el administrador:", error);
    status = 500;
    response = {
      message: "Error al validar el administrador",
      detail: error.message,
    };
  }

  res.status(status).json(response);
});

module.exports = router;