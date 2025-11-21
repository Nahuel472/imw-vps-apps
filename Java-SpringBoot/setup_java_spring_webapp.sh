#!/bin/bash

### --- CONFIGURACIÓN --- ###
USUARIO="isard"
APPDIR="/home/$USUARIO/webapp"
PORT="8081"


echo "==== 1) Instalando dependencias ===="
sudo apt update
sudo apt install -y openjdk-17-jdk git wget unzip


echo "==== 2) Descargando plantilla del proyecto ===="
cd /home/$USUARIO
wget -O webapp.zip https://github.com/Nahuel472/imw-vps-apps/raw/main/Java-SpringBoot/webapp.zip


echo "==== 3) Descomprimiendo proyecto ===="
unzip -o webapp.zip
cd webapp


echo "==== 4) Creando controlador MainController.java ===="
mkdir -p src/main/java/com/example/webapp/controller

cat << 'EOF' > src/main/java/com/example/webapp/controller/MainController.java
package com.example.webapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
public class MainController {

    @GetMapping("/")
    public String index(Model model, HttpServletRequest request) {
        DateTimeFormatter formato = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        model.addAttribute("lenguaje", "Java - Spring Boot");
        model.addAttribute("fechaHora", LocalDateTime.now().format(formato));
        model.addAttribute("ip", request.getRemoteAddr());
        model.addAttribute("navegador", request.getHeader("User-Agent"));
        model.addAttribute("versionJava", System.getProperty("java.version"));
        return "index";
    }

    @GetMapping("/contacto")
    public String contacto() {
        return "contacto";
    }
}
EOF


echo "==== 5) Creando vistas Thymeleaf ===="
mkdir -p src/main/resources/templates

### index.html ###
cat << 'EOF' > src/main/resources/templates/index.html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org" lang="es">
<head>
    <meta charset="UTF-8">
    <title>Aplicación Java - Spring Boot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light text-dark">
    <div class="container py-5">
        <div class="card shadow-lg p-4 border-0 rounded-4">
            <h1 class="text-center mb-4 text-primary">☕ Aplicación en <span th:text="${lenguaje}"></span></h1>
            <div class="row g-3">
                <div class="col-md-6">
                    <p><strong>📅 Fecha y hora:</strong> <span th:text="${fechaHora}"></span></p>
                    <p><strong>🌐 IP del cliente:</strong> <span th:text="${ip}"></span></p>
                </div>
                <div class="col-md-6">
                    <p><strong>🧭 Navegador:</strong> <span th:text="${navegador}"></span></p>
                    <p><strong>☕ Versión de Java:</strong> <span th:text="${versionJava}"></span></p>
                </div>
            </div>
            <div class="text-center mt-4">
                <a href="/contacto" class="btn btn-outline-primary">📬 Ir a contacto</a>
            </div>
        </div>
    </div>
</body>
</html>
EOF


### contacto.html ###
cat << 'EOF' > src/main/resources/templates/contacto.html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org" lang="es">
<head>
    <meta charset="UTF-8">
    <title>Contacto - Spring Boot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light text-dark">
    <div class="container py-5">
        <div class="card shadow-lg p-4 border-0 rounded-4">
            <h1 class="text-center text-success mb-4">📬 Formulario de contacto</h1>
            <form>
                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <input type="text" class="form-control" placeholder="Tu nombre">
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" placeholder="tu@email.com">
                </div>
                <div class="mb-3">
                    <label class="form-label">Mensaje</label>
                    <textarea class="form-control" rows="4" placeholder="Escribe tu mensaje..."></textarea>
                </div>
                <button type="submit" class="btn btn-primary w-100">Enviar</button>
            </form>
            <div class="text-center mt-4">
                <a href="/" class="btn btn-outline-secondary">🏠 Volver al inicio</a>
            </div>
        </div>
    </div>
</body>
</html>
EOF


echo "==== 6) Configurando application.properties ===="
cat << EOF > src/main/resources/application.properties
server.port=$PORT

spring.thymeleaf.cache=false
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html
EOF


echo "==== 7) Compilando aplicación ===="
./mvnw clean package -DskipTests


echo "==== 8) Creando servicio systemd ===="
sudo bash -c "cat << EOF > /etc/systemd/system/webapp.service
[Unit]
Description=Aplicación web Java Spring Boot
After=network.target

[Service]
User=$USUARIO
WorkingDirectory=$APPDIR
ExecStart=/usr/bin/java -jar $APPDIR/target/webapp-0.0.1-SNAPSHOT.jar
SuccessExitStatus=143
Restart=always

[Install]
WantedBy=multi-user.target
EOF"


echo "==== 9) Habilitando servicio ===="
sudo systemctl daemon-reload
sudo systemctl enable webapp
sudo systemctl restart webapp

echo "===================================================="
echo " DEPLOY COMPLETADO correctamente"
echo " Accede a la aplicación en:  http://<IP>:${PORT}"
echo "===================================================="
