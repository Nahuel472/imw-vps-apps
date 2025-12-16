# Tutorial Servidor Web para app básica en Java SpringBoot

Este tutorial te guiará paso a paso para crear una aplicación web básica en Java SpringBoot que muestre la fecha actual y la dirección IP del cliente, desplegada en Ubuntu Server 24.04. Cada paso incluye una breve explicación de su propósito.

## 1 Requisitos previos

### Entorno

* Máquina virtual **Ubuntu Server 24.04** (Isard)
* Red privada: `192.168.1.x/24`
* Usuario con permisos `sudo`

### Software necesario

```bash
sudo apt update
sudo apt install openjdk-17-jdk git wget unzip
```

Verificar la instalación de Java:

```bash
java -version
```

Salida esperada:

```text
openjdk version "17.0.x" 2025-xx-xx
```

---

## 2 Crear el proyecto Spring Boot

Crear el proyecto desde:

👉 [https://start.spring.io](https://start.spring.io)

**Configuración recomendada:**

* Project: Maven
* Language: Java
* Spring Boot: 3.4.11
* Group: `com.example`
* Artifact: `webapp`
* Dependencies:

  * Spring Web
  * Thymeleaf

Descargar el ZIP y subirlo al servidor:

```bash
scp webapp.zip usuario@192.168.1.x:/home/usuario/
unzip webapp.zip
cd webapp
```

---

## 3 Estructura del proyecto

Estructura típica de un proyecto Spring Boot:

```text
webapp/
 ├─ src/main/java
 ├─ src/main/resources
 │  ├─ templates
 │  └─ application.properties
 ├─ pom.xml
 └─ mvnw
```

---

## 4 Código de la aplicación

### Controlador principal

Ruta:

```text
src/main/java/com/example/webapp/controller/MainController.java
```

```java
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
```

---

### Vistas Thymeleaf

#### Página principal

Ruta:

```text
src/main/resources/templates/index.html
```

```html
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
```

#### Página de contacto

Ruta:

```text
src/main/resources/templates/contacto.html
```

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org" lang="es">
<head>
    <meta charset="UTF-8">
    <title>Contacto - Spring Boot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light text-dark">
    <div class="c
```

