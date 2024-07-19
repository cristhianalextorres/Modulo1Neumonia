# Utiliza la imagen base de Ubuntu
FROM ubuntu:20.04

# Establece la variable de entorno DEBIAN_FRONTEND para evitar preguntas interactivas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza la lista de paquetes e instala las dependencias necesarias
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    tk-dev \
    && apt-get clean

# Descarga e instala Python 3.11.9 desde la fuente
RUN wget https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz \
    && tar xzf Python-3.11.9.tgz \
    && cd Python-3.11.9 \
    && ./configure --enable-optimizations \
    && make altinstall \
    && cd .. \
    && rm -rf Python-3.11.9 Python-3.11.9.tgz

# Instala pip para Python 3.11.9
RUN wget https://bootstrap.pypa.io/get-pip.py \
    && python3.11 get-pip.py \
    && rm get-pip.py

# Limpia la caché de apt para reducir el tamaño de la imagen
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configura el directorio de trabajo
WORKDIR /app

# Copia los archivos necesarios al contenedor
COPY . /app

# Instala las dependencias del archivo requirements.txt
RUN python3.11 -m pip install --no-cache-dir -r requirements.txt

# Comando por defecto para ejecutar tu aplicación
# CMD ["python3.11", "tu_aplicacion.py"]
