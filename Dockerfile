# Use the official Python image with a specific tag
FROM python:3.13.1-bullseye

# Set environment variables for Python
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Create and set working directory
RUN mkdir -p /app
WORKDIR /app

# Install system dependencies required for Python packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies first for layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Security: Run as non-root user (recommended for production)
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Expose port and run application
EXPOSE 8000

# Use gunicorn instead of runserver for production
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]