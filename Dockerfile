# Беремо легкий Python image
FROM python:3.8-slim

# Увімкнемо python оптимізації
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Встановлюємо системні залежності
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*

# Створюємо робочу директорію
WORKDIR /app

# Ставимо залежності окремо (оптимізація кешу)
COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо весь проект
COPY . .

RUN python3 manage.py collectstatic

# Стандартний порт gunicorn
EXPOSE 8899

# Запуск
CMD ["gunicorn", "backend.wsgi:application", "--bind", "0.0.0.0:8899"]
