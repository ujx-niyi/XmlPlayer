# ──────────────────────────────────────────────
# Dockerfile — Lightweight layer (rebuild often)
# ──────────────────────────────────────────────
FROM playwright-base:latest

WORKDIR /app
COPY . /app
ENV PYTHONPATH=/app

# Restore default mirrors (safer than Cloudflare)
RUN echo "deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://security.ubuntu.com/ubuntu jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y default-jre wget unzip && \
    wget -q https://github.com/allure-framework/allure2/releases/download/2.29.0/allure-2.29.0.zip -O /tmp/allure.zip && \
    unzip /tmp/allure.zip -d /opt/ && \
    ln -s /opt/allure-2.29.0/bin/allure /usr/local/bin/allure && \
    rm /tmp/allure.zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["bash", "-c", "\
case \"$1\" in \
  pytest) shift; echo '🧪 Running pytest...'; pytest \"$@\" ;; \
  allure) shift; echo '📊 Generating Allure report...'; allure \"$@\" ;; \
  bash) shift; bash \"$@\" ;; \
  *) echo '▶ Running Excel converter...'; python excel_to_xml_converter.py \"$@\" ;; \
esac"]
