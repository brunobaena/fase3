FROM python:3.14.6-slim AS builder

RUN python3 -m venv /venv
ENV PATH=/venv/bin:$PATH

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


FROM python:3.14.6-slim

RUN addgroup --system app && adduser --system --ingroup app app

COPY --from=builder /venv /venv
ENV PATH=/venv/bin:$PATH

WORKDIR /app

COPY --chown=app:app app.py .

USER app

EXPOSE 8003

CMD ["gunicorn", "--bind", "0.0.0.0:8003", "app:app"]
