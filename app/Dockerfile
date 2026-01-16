# 1. Use a specific version for consistency
FROM python:3.10-slim

# 2. Set the working directory
WORKDIR /app

# 3. Create a non-root user for security (2026 Best Practice)
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# 4. Install dependencies FIRST (Better caching)
# Note: It's better to use a requirements.txt, but for your single package:
RUN pip install --no-cache-dir flask

# 5. Copy the application code
COPY api.py .

# 6. Change ownership of the app directory to the non-root user
RUN chown -R appuser:appgroup /app

# 7. Switch to the non-root user
USER appuser

# 8. Expose the port
EXPOSE 5000

# 9. Run the application
CMD ["python", "api.py"]
