ARG PYTHON
FROM python:3.10

WORKDIR /playground
RUN useradd -m iac

ENV PATH="/root/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TTPCACHEFOLDER=/tmp/


RUN apt-get update && apt-get install curl -y \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://install.python-poetry.org | python3 \
    && poetry config virtualenvs.create false

COPY --chown=iac:iac pyproject.toml .
COPY --chown=iac:iac poetry.lock .

# poetry does not support subdirectory yet
RUN poetry install --no-dev --no-interaction --no-ansi

COPY --chown=iac:iac . .

USER iac

EXPOSE 5000/tcp

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "flask_app:app"]