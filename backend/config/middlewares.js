const jwt = require('jsonwebtoken');

function jwtMiddleware(req, res, next) {
  
  // Obtener el token del encabezado Authorization
  const authHeader = req.headers['authorization'];
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      message: "No se proporcionó un token",
      detail: null
    });
  }

  const token = authHeader.split(' ')[1]; // Extraer solo el token

  try {
    // Verificar y decodificar el token
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback-secret-key');
    
    // Guardar los datos del token (por ejemplo el id, username, etc.) en req.user
    req.user = decoded;

    // Continuar al siguiente middleware o ruta
    next();
  } catch (error) {
    console.error("Error al verificar el token:", error);
    return res.status(401).json({
      message: "JWT no válido",
      detail: error.message
    });
  }
}

module.exports = {
  jwtMiddleware,
};