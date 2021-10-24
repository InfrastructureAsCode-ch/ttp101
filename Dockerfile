ARG PYTHON
FROM python:3.8

WORKDIR /jinja101
RUN useradd -m jinja101

ENV PATH="/root/.poetry/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1


RUN apt-get update && apt-get install curl -y \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python \
    && poetry config virtualenvs.create false

COPY --chown=jinja101:jinja101 pyproject.toml .
COPY --chown=jinja101:jinja101 poetry.lock .

# poetry does not support subdirectory yet
RUN pip install "git+https://github.com/StackStorm/st2-rbac-backend.git@master#egg=st2-rbac-backend" \
    && pip install "git+https://github.com/StackStorm/st2.git@v3.3.0#subdirectory=st2common" \
    && poetry install --no-dev --no-interaction --no-ansi

COPY --chown=jinja101:jinja101 . .

USER jinja101

EXPOSE 5000/tcp

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "flask_app:app"]