const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const morgan = require("morgan");
const homeController = require("./app/controllers/home_controller");
const addressController = require("./app/controllers/address_controller");
const adminController = require("./app/controllers/admin_controller");
const companyController = require("./app/controllers/company_controller");
const contactController = require("./app/controllers/contact_controller");
const dependencyController = require("./app/controllers/dependency_controller");
const invoiceController = require("./app/controllers/invoice_controller");
const ispController = require("./app/controllers/isp_controller");
const ispServiceController = require("./app/controllers/isp_service_controller");
const providerController = require("./app/controllers/provider_controller");
const providerServiceController = require("./app/controllers/provider_service_controller");
const chatSocket = require("./app/sockets/chat_socket");

const app = express();
const server = http.createServer(app);
const io = new Server(server);

// Configuración de la app
app.set("view engine", "ejs");
app.set("views", "./views");

// Middlewares y rutas
app.use(morgan("dev"));
app.use(express.json());
app.use(express.static("public"));
app.use("/", homeController);
app.use("/addresses", addressController);
app.use("/admins", adminController);
app.use("/companies", companyController);
app.use("/contacts", contactController);
app.use("/dependencies", dependencyController);
app.use("/invoices", invoiceController);
app.use("/isps", ispController);
app.use("/ispServices", ispServiceController);
app.use("/providers", providerController);
app.use("/providerServices", providerServiceController);

// Sockets
chatSocket(io);

// ✅ Usar el puerto dinámico de Replit o 3000 por defecto
const PORT = process.env.PORT || 3000;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor corriendo en http://0.0.0.0:${PORT}`);
});
